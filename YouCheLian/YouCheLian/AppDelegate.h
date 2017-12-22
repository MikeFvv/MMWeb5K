//
//  AppDelegate.h
//  YouCheLian
//
//  Created by Mike on 15/11/4.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHTabBarViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) YHTabBarViewController *tab;

@property(nonatomic,assign) float scale;
@property (nonatomic, strong) BMKMapManager *mapManager;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (nonatomic, strong) NSDictionary *launchOptions;
@property (nonatomic, strong) UIViewController *nativeRootController;
@property (nonatomic, strong) UIViewController *reactNativeRootController;
@property (nonatomic, strong) UIViewController *webRootController;

@property (nonatomic, copy) NSString *is_jump;
@property (nonatomic, copy) NSString *pushKey;
@property (nonatomic, assign) NSString *mmUrl;
@property (nonatomic, assign) NSInteger mmStatus;
@property (nonatomic, assign) BOOL isRoute;

@end
