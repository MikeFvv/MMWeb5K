//
//  UIWindow+Extension.m
//  YouCheLian
//
//  Created by Mike on 16/4/27.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "YHTabBarViewController.h"

#import "GuidePages.h"
#import "LoginViewController.h"
#import "YHNavigationController.h"

@implementation UIWindow (Extension)

- (void)switchRootViewController
{
    
    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    if ([currentVersion isEqualToString:lastVersion])
    { // 版本号相同：这次打开和上次打开的是同一个版本
        
        // 读取用户信息
        [YHFunction readUserInfo];
        
        if ([YHUserInfo shareInstance].isLogin)
        {
            // 登录过  重新登录 刷新数据
            [self updateAccountInfo];
            
        }else {
            // 没登录过
        }
 
    } else { // 这次打开的版本和上一次不一样，显示新特性
        
        
        /// 引导页
        [self guidePages];
        // 将当前的版本号存进沙盒
        [UserDefaultsTools setObject:currentVersion forKey:key];
    }
}


#pragma mark - 登录 更新账号信息
///  导航页
- (void)guidePages
{
    // 图片数据源
    NSArray *imageArray = @[ @"guide_0.jpg", @"guide_1.jpg", @"guide_2.jpg"];
    
    //  初始化方法1
    GuidePages *mzgpc = [[GuidePages alloc] init];
    mzgpc.imageDatas = imageArray;
    __weak typeof(GuidePages) *weakMZ = mzgpc;
    mzgpc.buttonAction = ^{
        [UIView animateWithDuration:2.0f
                         animations:^{
                             weakMZ.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [weakMZ removeFromSuperview];
                         }];
    };
    
    //要在makeKeyAndVisible之后调用才有效
    [self addSubview:mzgpc];
    
}



#pragma mark - 登录 更新账号信息
/// 更新账号信息
- (void)updateAccountInfo {
    
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1008" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    
    NSString *service = [NSBundle mainBundle].bundleIdentifier;  // 获取唯一的字符标识
    // 取密码
    NSString *password = [SSKeychain passwordForService:service account:[YHUserInfo shareInstance].uPhone];
    
    [dictParam setValue:password forKey:@"rec_pwd"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@" ===== %@", result);
        
        if (error) {
            
            
        } else {
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                
                //解析数据,把数据保存放置在内存上
                [YHUserInfo pareseUserInfo:result];
                
                NSMutableDictionary *loginMDict = [NSMutableDictionary dictionary];
                // 登录成功 跳转页面
                if ([YHUserInfo shareInstance].isLogin == YES) {
                    // 需要把数据保存在沙盒  写入用户数据  <<<
                    [result enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                        //                        NSLog(@"%@ = %@",key,obj);
                        
                        if (result[key] == nil || [result[key] isEqual:[NSNull null]]) {
                            loginMDict[key] = @"";
                        }else {
                            loginMDict[key] = obj;
                        }
                    }];
                    
                    // 数据保存本地持久化 plist 文件
                    [YHFunction saveUserInfoWithDic:loginMDict];
                    
                }
            } else {
                
                YHLog(@"登录失败");
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"安全提示" message:@"身份验证失败，请您重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        return YES;
    }];
}


#pragma mark - 重新登录
// 重新登录
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // 发送通知 重新登录
    [[NSNotificationCenter defaultCenter]postNotificationName:ReLoginNotification object:nil];
}


@end
