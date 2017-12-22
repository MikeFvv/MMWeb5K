//
//  BaseViewController.m
//  YouCheLian
//
//  Created by Mike on 15/11/4.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "BaseViewController.h"
#import <UIView+Toast.h>
#import "MBProgressHUD.h"
@interface BaseViewController ()
{
    MBProgressHUD *HUD;
}



@end



@implementation BaseViewController

//初始化 para array
- (void)awakeFromNib{
    [super awakeFromNib];
}

- (id)init{
    if (self = [super init]) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kViewControllerColor;
    [self setBaseNav];
    
}

-(void)setBaseNav {
    // 设置title的字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:kNavTitleFont18,
       NSForegroundColorAttributeName:kFontColor}];
    
    // Nav 返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = kNav_Back_CGRectMake;
    
    //    // 返回按钮内容左靠
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // 让返回按钮内容继续向左边偏移10
    //    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    
    [backBtn setImage:[UIImage imageNamed:@"Search_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}


-(void)onBackBtn:(UIButton *)sender {
    // 在push控制器时显示UITabBar
    self.hidesBottomBarWhenPushed = NO;
    // 将栈顶的控制器移除
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showLoadingView{
    
    HUD = [[MBProgressHUD alloc]initWithView:self.view];
    [HUD show:YES];
    [self.view addSubview:HUD];
}


- (void)hidenLoadingView{
    
    if (HUD != nil) {
        [HUD hide:YES];
        [HUD removeFromSuperViewOnHide];
        HUD = nil;
    }
}


- (void)showLoadingViewWithText:(NSString *)str{
    
    HUD = [[MBProgressHUD alloc]initWithView:self.view];
    HUD.labelText = str;
    [HUD show:YES];
    [self.view addSubview:HUD];
}



- (void)showErrorMessage:(NSString *)message{
    [self.view makeToast:message];
}

- (void)viewWillAppear:(BOOL)animated {
    // 显示隐藏导航栏
    self.navigationController.navigationBarHidden = self.isShowNav;
}

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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
