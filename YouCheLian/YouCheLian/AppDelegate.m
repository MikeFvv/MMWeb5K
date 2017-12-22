//
//                       .::::.
//                     .::::::::.
//                    :::::::::::
//                 ..:::::::::::'
//              '::::::::::::'
//                .::::::::::
//           '::::::::::::::..
//                ..::::::::::::.
//              ``::::::::::::::::
//               ::::``:::::::::'        .:::.
//              ::::'   ':::::'       .::::::::.
//            .::::'      ::::     .:::::::'::::.
//           .:::'       :::::  .:::::::::' ':::::.
//          .::'        :::::.:::::::::'      ':::::.
//         .::'         ::::::::::::::'         ``::::.
//     ...:::           ::::::::::::'              ``::.
//    ```` ':.          ':::::::::'                  ::::..
//                       '.:::::'                    ':'````..
//
//  AppDelegate.m
//  YouCheLian
//
//  Created by Mike on 15/11/4.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "AppDelegate.h"
#import "YHLocationManager.h"
#import "WXApi.h"
#import <IQKeyboardManager.h>

#import "AppDelegate+MMFun.h"


@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.launchOptions = launchOptions;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self setLoadConfigThirdService];
    
    [self.window makeKeyAndVisible];
    return YES;
    
}




#warning 需要配置RN环境 参考: http://reactnative.cn/docs/0.51/getting-started.html
#pragma mark - 马甲页面入口  ⭕️推送已经写好，集成别人代码需要将推送功能全部去掉！
// ⭕️ 1. 手动调试代码时在 AppMacros.h 类修改
//    2. 需要修改 BundleIdntifier  版本号  默认的0.0.1可以测试
- (UIViewController *)nativeRootController {
    if (!_nativeRootController) {
        // ❌  ⚠️壳入口⚠️   UIViewController 替换自己的入口
        
        // 这里要写前面， 不然 window分类用不了
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
        
        /*******   键盘 头上工具条 隐藏  *******/
        /*
         enable控制整个功能是否启用。
         shouldResignOnTouchOutside控制点击背景是否收起键盘。
         shouldToolbarUsesTextFieldTintColor 控制键盘上的工具条文字颜色是否用户自定义。
         enableAutoToolbar控制是否显示键盘上的工具条。
         */
        IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
        manager.enable = YES;
        manager.shouldResignOnTouchOutside = YES;
        //    manager.shouldToolbarUsesTextFieldTintColor = YES;
        manager.enableAutoToolbar = NO;
        
        
        /*******   注册微信SDK  *******/
        [WXApi registerApp:kWeiXinKey withDescription:@" "];
        
        
        /*******   百度地图  *******/
        // 要使用百度地图，请先启动BaiduMapManager
        _mapManager = [[BMKMapManager alloc]init];
        // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
        
        //    scq0wVGd6IhnjltMg9SjtCeg    // 百度地图 sdk 密钥
        BOOL ret = [_mapManager start:kBaiduMapKey  generalDelegate:nil];
        if (!ret) {
            YHLog(@"《百度地图》 manager 启动失败!");
        }
        
        // 获取定位授权
        [[YHLocationManager shareInstance] getAuthorization];
        
        // 进入主页
        //        self.window.rootViewController = [[YHTabBarViewController alloc]init];
        //        [self setRootWindow];
        
        _nativeRootController =  [[YHTabBarViewController alloc]init];;
        _nativeRootController.view.backgroundColor = [UIColor whiteColor];
    }
    return _nativeRootController;
}







- (void)YouCheLian {
    
    // 这里要写前面， 不然 window分类用不了
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    /*******   键盘 头上工具条 隐藏  *******/
    /*
     enable控制整个功能是否启用。
     shouldResignOnTouchOutside控制点击背景是否收起键盘。
     shouldToolbarUsesTextFieldTintColor 控制键盘上的工具条文字颜色是否用户自定义。
     enableAutoToolbar控制是否显示键盘上的工具条。
     */
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    //    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    
    /*******   注册微信SDK  *******/
    [WXApi registerApp:kWeiXinKey withDescription:@" "];
    
    
    /*******   百度地图  *******/
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    
    //    scq0wVGd6IhnjltMg9SjtCeg    // 百度地图 sdk 密钥
    BOOL ret = [_mapManager start:kBaiduMapKey  generalDelegate:nil];
    if (!ret) {
        YHLog(@"《百度地图》 manager 启动失败!");
    }
    
    // 获取定位授权
    [[YHLocationManager shareInstance] getAuthorization];
    
    // 进入主页
    self.window.rootViewController = [[YHTabBarViewController alloc]init];
    [self setRootWindow];
}




- (void)setRootWindow {
    
    [self.window switchRootViewController];
}


- (void)changeRoot {
    // 进入主页
    self.window.rootViewController = [[YHTabBarViewController alloc]init];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}



@end
