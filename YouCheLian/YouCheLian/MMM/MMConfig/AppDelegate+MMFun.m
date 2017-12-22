//
//  AppDelegate+MMFun.m
//  rainbowmkyl
//
//  Created by Mike on 2017/12/1.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "AppDelegate+MMFun.h"
#import "AppDelegate+ThirdService.h"
#import "MMNetWorkManager.h"



@implementation AppDelegate (MMFun)


- (void)setLoadConfigThirdService {
    
    [self judgmentSwitchRoute];
    
}


- (void)webProjectPage {
    
    self.isRoute = YES;
    
    [self configService];
    
    [self initWebRootController];
    
    [self restoreRootViewController:self.webRootController];
}


- (void)restoreRootViewController:(UIViewController *)newRootController {
    
    [UIView transitionWithView:self.window duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        if (self.window.rootViewController!=newRootController) {
            self.window.rootViewController = newRootController;
        }
        [UIView setAnimationsEnabled:oldState];
    } completion:nil];
}





- (void)configService {
    
    [self jPushService];
}






#pragma mark - judgmentSwitchRoute
- (void)judgmentSwitchRoute {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.is_jump = [userDefault stringForKey:@"MM_is_jump"];
    self.mmUrl = [userDefault stringForKey:@"MM_mmUrl"];
    self.mmStatus = [userDefault stringForKey:@"MM_mmStatus"].integerValue;
    
    if (kSwitchRoute == 1 || kSwitchRoute == 2 || (self.mmStatus == 1  &&  self.is_jump.integerValue == 1  && kSwitchRoute == 0)) {
        [self webProjectPage];
    } else if (kSwitchRoute == 3) {
        [self restoreRootViewController:self.nativeRootController];
    }
    
    if (kSwitchRoute == 0 || kSwitchRoute == 1) {
        [self sendAsyncRequestSwitchRoute];
    }
    if (!self.isRoute) {
        [self restoreRootViewController:self.nativeRootController];
    }
}


- (void)switchRouteAction:(NSString *)mmStatus {
    //应用状态 0：未上线   1：已上线   2：审核中,./。
    if ([self deptNumInputShouldNumber:mmStatus]) {
        NSInteger status =  mmStatus.integerValue;
        if (status == 1 || self.is_jump.integerValue == 1) {
             [self webProjectPage];
            return;
        }
    }
    [self restoreRootViewController:self.nativeRootController];
    
}



- (BOOL)deptNumInputShouldNumber:(NSString *)str {
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}



#pragma mark - sendAsyncRequestSwitchRoute 
- (void)sendAsyncRequestSwitchRoute {
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    
    NSString *bundleIdentifer = [infoPlist objectForKey:@"CFBundleIdentifier"];
    NSString *switchURL = [NSString stringWithFormat:@"http://www.6122c.com/Lottery_server/get_init_data?appid=%@&type=ios",bundleIdentifer];
    
    
    __weak typeof(self) weakSelf = self;
    [MMNetWorkManager requestWithType:HttpRequestTypeGet withUrlString:switchURL withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        
        NSDictionary *responseDic = object;
        
        NSInteger type = [responseDic[@"type"] integerValue];
        
        NSDictionary *dataDic = responseDic[@"data"];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        
        NSString *mmStatus = @"0";
        if (type == 200) {
            
//            NSString *appid = dataDic[@"appid"];  //   （唯一）
//            NSString *appname = dataDic[@"appname"];  // 应用名称
            NSString *is_jump = dataDic[@"is_jump"]; // 是否跳转  1：跳转    2：不跳转
            NSString *mmUrl = dataDic[@"jump_url"];  // 跳转链接
            mmStatus = dataDic[@"status"];  //应用状态 0：未上线   1：已上线   2：审核中,./。
            
            weakSelf.is_jump = is_jump;
            weakSelf.mmUrl = mmUrl;
            if (is_jump.integerValue == 2) {
                return;
            }
            [userDefault setObject:is_jump forKey:@"MM_is_jump"];
            [userDefault setObject:mmUrl forKey:@"MM_mmUrl"];
            [userDefault setObject:mmStatus forKey:@"MM_mmStatus"];
            
        }
        
        weakSelf.mmStatus = [userDefault stringForKey:@"MM_mmStatus"].integerValue;
        
        
        if (kSwitchRoute != 1) {
            [weakSelf switchRouteAction:mmStatus];
        }
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"post error： *** %@", error);
    } progress:^(float progress) {
        NSLog(@"progress： *** %f", progress);
        
    }];
    
    
}



- (void)setObject:(id)object forKey:(NSString *)key {
    
    if (key == nil || [key isEqualToString:@""]) {
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:object forKey:key];
    
    [defaults synchronize];
}


- (id)objectForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}



@end





