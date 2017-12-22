//
//  DSLocationManager.h
//  YouCheLian
//
//  Created by Mike on 15/11/5.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class YHLocationManager;

@protocol YHLocationManagerDelegate <NSObject>

- (void)YHLocationManager:(YHLocationManager *)manager changeCurrentCity:(NSString *)cityName;

@end



@interface YHLocationManager : NSObject

@property (nonatomic,weak) id<YHLocationManagerDelegate> delegate;

+ (YHLocationManager *)shareInstance;

//获取权限
- (void)getAuthorization;
// 判断是否打开定位
- (BOOL)isAuthorization;
//开始定位
- (void)startLocation;
//结束定位
- (void)stopLocation;
//获取当前城市名称
- (NSString *)getCityName;

//WGS-84 世界坐标
- (CLLocationCoordinate2D)WGSLocation;
//中国坐标
- (CLLocationCoordinate2D)GCJlocation;
//百度坐标
- (CLLocationCoordinate2D)BDlocation;



@end
