//
//  ChangePasswordController.m
//  YouCheLian
//
//  Created by Mike on 15/12/1.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "ChangePasswordController.h"
#import "JKCountDownButton.h"

#import "LoginViewController.h"
#import "YHNavigationController.h"
#import "NSString+RegexCategory.h"

@interface ChangePasswordController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPwdField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *conPwdField;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation ChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor colorWithRed:0.914  green:0.957  blue:0.976 alpha:1];
    // 圆角
    self.confirmBtn.layer.cornerRadius = 5.0;
    _confirmBtn.backgroundColor = kLightGrayColor;
    _confirmBtn.enabled = NO;
    
    
    // 添加手势，点击屏幕其他区域关闭键盘的操作
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
//    gesture.numberOfTapsRequired = 1;
//    gesture.delegate = self;
//    [self.view addGestureRecognizer:gesture];
}

#pragma mark - 键盘操作
//- (void)hidenKeyboard
//{   // 点击屏幕键盘消失
//    [_oldPwdField resignFirstResponder];
//    [_passwordField resignFirstResponder];
//    [_conPwdField resignFirstResponder];
//}

///  确认修改
- (IBAction)confirmChangesAction:(UIButton *)sender {
    // 如果信息填写不完整
    if ([_oldPwdField.text isEqualToString:@""] )
    {
        [self showMessage:@"请输入旧密码" delay:2];

    }else if (![_passwordField.text passwordCheck])
    {
        [self showPassHint:PasswordCheckMessage];
        
    }else if (![_passwordField.text isEqualToString:_conPwdField.text])  // 两次填写的密码是否相同
    {
        [self showMessage:PasswordNotConsistent delay:2];
    }else
    {
        [self ChangesPasswordInterface];
    }
}

///  密码
- (void)ChangesPasswordInterface {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1010" forKey:@"rec_code"];
    
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; // 用户注册手机号
    [dictParam setValue:_oldPwdField.text forKey:@"rec_pwdOld"];  // 旧密码
    [dictParam setValue:_passwordField.text forKey:@"rec_pwd"];  // 密码
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    // 开始显示加载图标
    [self showLoadingView];
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        // 隐藏加载图标
        [self hidenLoadingView];
        if (error) {
            
        } else {
            YHLog(@"%@", result);
            // 提示信息
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            
            if ( [result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                
                // ***** 修改钥匙串密码 *****
                NSString *service = [NSBundle mainBundle].bundleIdentifier;  // 获取唯一的字符标识
                [SSKeychain setPassword:_passwordField.text forService:service account:[YHUserInfo shareInstance].uPhone];
                
                
                // 跳转到登录
                //                [self JumpLoginPage];
                
                // 在push控制器时隐藏UITabBar
                //                self.hidesBottomBarWhenPushed = NO;
                // 将栈顶的控制器移除
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        
        return YES;
    }];
}

- (void)showPassHint:(NSString *)hint
{
    [self hideHud];
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = hint;
    hud.margin = 10.f;
    hud.yOffset = -(view.height*0.5-64-64*0.5);
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0f];
}


///  跳转到登录页面
- (void)JumpLoginPage {
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.loginOrReg = YES;
    YHNavigationController *loginView = [[YHNavigationController alloc] initWithRootViewController:loginVC];
    
    [self presentViewController:loginView animated:YES completion:nil];
}


// Field 事件
- (IBAction)returnOnkeyboard:(UITextField *)sender {
    
    if (_oldPwdField.text.length > 0 && _passwordField.text.length > 0 && _conPwdField.text.length > 0) {
        _confirmBtn.backgroundColor = kGreenColor;
        _confirmBtn.enabled = YES;
    }
    if (_oldPwdField.text.length == 0 || _passwordField.text.length == 0 || _conPwdField.text.length == 0) {
        _confirmBtn.backgroundColor = kLightGrayColor;
        _confirmBtn.enabled = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

