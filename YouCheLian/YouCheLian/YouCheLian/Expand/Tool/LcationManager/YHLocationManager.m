//
//  DSLocationManager.m
//  YouCheLian
//
//  Created by Mike on 15/11/5.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "YHLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "JZLocationConverter.h"
@interface YHLocationManager ()<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    BOOL flag;//用于标记定位成功
}

//管理器
@property (nonatomic,strong) CLLocationManager *manager;
//地理编码
@property (nonatomic,strong) CLGeocoder *geocoder;
//当前城市名称
@property (nonatomic,copy) NSString *city;
//当前WGS经纬度
@property (nonatomic,strong) CLLocation *currentLoc;

@end


@implementation YHLocationManager

- (id)init{
    
    if (self = [super init]) {
        
        _manager = [[CLLocationManager alloc]init];
        
        //        if ([_manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        //            [_manager requestAlwaysAuthorization];
        //            [_manager requestWhenInUseAuthorization];
        //        }
        
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;//定位精确度
        _manager.distanceFilter = 10;//10米定位一次
        
        _city = [UserDefaultsTools stringForKey:kCityName];
        //[_manager startUpdatingLocation];
    }
    
    return self;
    
}

+ (YHLocationManager *)shareInstance{
    
    static YHLocationManager *man = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        man = [[YHLocationManager alloc]init];
        
    });
    
    return man;
    
}

- (void)getAuthorization
{
    if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                break;
                
            case kCLAuthorizationStatusNotDetermined:
                [self.manager requestWhenInUseAuthorization];
                break;
            case kCLAuthorizationStatusDenied:
                [self alertOpenLocationSwitch];
                break;
            default:
                break;
        }
    }
    
}


- (BOOL)isAuthorization {
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self alertOpenLocationSwitch];
        return NO;
    }
    return YES;
}

- (void)alertOpenLocationSwitch
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在隐私设置中打开定位开关" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)startLocation {
    
    [_manager startUpdatingLocation];
}
- (void)stopLocation {
    
    [_manager stopUpdatingLocation];
}

- (NSString *)getCityName
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return @"未知";
    }else{
        return _city;
    }
    
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

//- (CLLocation *)currentLoc{
//    if (!_currentLoc) {
//        _currentLoc = [[CLLocation alloc] initWithLatitude:0 longitude:0];
//    }
//    return _currentLoc;
//}

#pragma mark -  坐标转换
//WGS-84 国际坐标
- (CLLocationCoordinate2D)WGSLocation {
    return self.currentLoc.coordinate;
}
//中国坐标
- (CLLocationCoordinate2D)GCJlocation {
    return [JZLocationConverter wgs84ToGcj02:self.currentLoc.coordinate];
}
//百度坐标
- (CLLocationCoordinate2D)BDlocation {
    return [JZLocationConverter wgs84ToBd09:self.currentLoc.coordinate];
}


#pragma mark --CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusDenied) {
        
        
        [_manager stopUpdatingLocation];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //获取当前地址
    self.currentLoc = locations.lastObject;
    //反地理编码
    [self reverseGeocodeCurrentLocation];
    
}

//反地理编码
- (void)reverseGeocodeCurrentLocation{
    
    [self.geocoder reverseGeocodeLocation:self.currentLoc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@",error.description);
            
        } else {
            CLPlacemark *pm = [placemarks firstObject];
            
            YHLog(@"%@",pm.locality);
            if (![pm.locality isEqualToString:self.city]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位城市为%@,是否修改？",pm.locality] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                
                self.city = pm.locality;
                
                
            }
            
        }
    }];
}

#pragma mark - UIAlertViewDelegate
//修改定位城市
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    YHLog(@"%ld",buttonIndex);
    if(buttonIndex == 1){
        //修改定位城市
        if ([self.delegate respondsToSelector:@selector(YHLocationManager:changeCurrentCity:)]){
            [self.delegate YHLocationManager:self changeCurrentCity:self.city];
        }
        
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    
    
}


@end
