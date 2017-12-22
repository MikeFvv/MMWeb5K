/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;


@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD
{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD
{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = hint;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}


///  提示框
///
///  @param hint 提示内容   延时时间 2 秒
- (void)showHint:(NSString *)hint
{
    [self hideHud];
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = -(view.height*0.5-64-64*0.5);
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0f];
}


- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = -(view.height*0.5-64-64*0.5);
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0f];
}

- (void)hideHud
{
    [[self HUD] hide:YES];
}


- (void)showLoadingView {
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
    
}


- (void)hidenLoadingView {
    
    [[self HUD] hide:YES];
}



/*****************************************/

///  警告框
///
///  @param message 内容
///  @param delay   延时时间 秒
- (void)showMessage:(NSString *)message delay:(NSTimeInterval)delay {
    MBProgressHUD *hub = [[MBProgressHUD alloc] init];
    hub.mode = MBProgressHUDModeText;
    hub.labelText = message;
    [hub show:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:hub];
    [hub hide:YES afterDelay:delay];
}


@end
