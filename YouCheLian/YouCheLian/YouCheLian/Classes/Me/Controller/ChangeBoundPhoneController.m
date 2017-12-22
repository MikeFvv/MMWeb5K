//
//  ChangeBoundPhoneController.m
//  YouCheLian
//
//  Created by Mike on 15/11/23.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "ChangeBoundPhoneController.h"
#import "JKCountDownButton.h"
#import "LoginViewController.h"
#import "YHNavigationController.h"

#import "NSString+RegexCategory.h"

@interface ChangeBoundPhoneController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;
@property (weak, nonatomic) IBOutlet UITextField *passwordFiled;
@property (weak, nonatomic) IBOutlet UITextField *phoneNewFiled;
@property (weak, nonatomic) IBOutlet UITextField *VerificationCodeFiled;

@property (weak, nonatomic) IBOutlet JKCountDownButton *getVerificationCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

// 是否在倒计时当中
@property (nonatomic, assign) BOOL isDownTime;

@end

@implementation ChangeBoundPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    
    // 键盘模式
    _phoneNumField.keyboardType=UIKeyboardTypePhonePad;
    _phoneNumField.userInteractionEnabled = NO;
    
    _phoneNumField.text = [YHUserInfo shareInstance].uPhone;
    
    _phoneNewFiled.keyboardType=UIKeyboardTypePhonePad;
    
    
    _VerificationCodeFiled.keyboardType=UIKeyboardTypeNumberPad;
    
    self.title = @"更换绑定手机号码";
    self.view.backgroundColor = [UIColor colorWithRed:0.914  green:0.957  blue:0.976 alpha:1];
    // 圆角
    _getVerificationCodeBtn.layer.cornerRadius = 5.0;
    _getVerificationCodeBtn.backgroundColor = kLightGrayColor;
    _getVerificationCodeBtn.enabled = NO;
    
    _submitBtn.layer.cornerRadius = 5.0;
    _submitBtn.backgroundColor = kLightGrayColor;
    _submitBtn.tintColor = [UIColor whiteColor];
    _submitBtn.enabled = NO;
}


#pragma -mark 获取短信验证码
/// 注册 获取短信验证码
- (IBAction)getVerificationCodeAction:(JKCountDownButton *)sender {
    
    if (![_phoneNewFiled.text isMobileNumber]) {
        [self showMessage:@"新手机号填写格式错误" delay:1.5];
        
    } else {
        sender.enabled = NO;
        //button type要 设置成custom 否则会闪动
        [sender startWithSecond:120];
        sender.backgroundColor = kLightGrayColor;
        __weak typeof(self) weakSelf = self;
        
        [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
            weakSelf.isDownTime = YES;
            NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
            return title;
        }];
        [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
            weakSelf.isDownTime = NO;
            
            if (weakSelf.phoneNewFiled.text.length > 0) {
                countDownButton.enabled = YES;
                sender.backgroundColor = kColorDarkGreen;
            }
            
            return @"获取验证码";
        }];
        
        [self VerificationCodeInterfaceData];
    }
}

///  验证码接口
- (void)VerificationCodeInterfaceData {
    // 请求数据
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1007" forKey:@"rec_code"];
    [dictParam setValue:@"2" forKey:@"rec_type"]; // 1 注册 2更改绑定手机 3忘记密码
    [dictParam setValue:_phoneNewFiled.text forKey:@"rec_userPhone"];
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    // 开始显示加载图标
    [self showLoadingView];
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        if (error) {
            
        } else {
            if ([result[@"res_num"] isEqualToString:@"0"]) {
                
                YHLog(@"验证码结果===%@", result);
                _getVerificationCodeBtn.enabled = NO;
                //button type要 设置成custom 否则会闪动
                [_getVerificationCodeBtn startWithSecond:120];
                _getVerificationCodeBtn.backgroundColor = kLightGrayColor;
                __weak typeof(self) weakSelf = self;
                
                
                [_getVerificationCodeBtn didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                    weakSelf.isDownTime = YES;
                    _getVerificationCodeBtn.backgroundColor = kLightGrayColor;
                    NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
                    return title;
                }];
                [_getVerificationCodeBtn didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                    weakSelf.isDownTime = NO;
                    
                    if (weakSelf.phoneNumField.text.length > 0) {
                        countDownButton.enabled = YES;
                        _getVerificationCodeBtn.backgroundColor = kColorDarkGreen;
                    }
                    return @"获取验证码";
                }];
                
                [self showMessage:result[@"res_desc"] delay:2];
                
            }else{
                
                [self showMessage:result[@"res_desc"] delay:2];
                
            }
        }
        // 隐藏加载图标
        [self hidenLoadingView];
        return YES;
    }];
}

/// Field 事件
- (IBAction)changedField:(UITextField *)sender {
    
    if (_phoneNumField.text.length > 0 && _passwordFiled.text.length > 0 && _phoneNewFiled.text.length > 0  && _VerificationCodeFiled.text.length > 0 ) {
        _submitBtn.backgroundColor = kGreenColor;
        _submitBtn.enabled = YES;
    }
    if (_phoneNumField.text.length == 0 || _passwordFiled.text.length == 0 || _phoneNewFiled.text.length == 0  || _VerificationCodeFiled.text.length == 0 ) {
        _submitBtn.backgroundColor = kLightGrayColor;
        _submitBtn.enabled = NO;
    }
    
    if (self.isDownTime == YES) {
        return;  // 在计时当中直接返回 不走下面的代码
    }
    
    // 验证码 状态转换
    if (_phoneNewFiled.text.length > 0) {
        _getVerificationCodeBtn.backgroundColor = kColorDarkGreen;
        _getVerificationCodeBtn.enabled = YES;
    }
    if (_phoneNewFiled.text.length == 0) {
        _getVerificationCodeBtn.backgroundColor = kLightGrayColor;
        _getVerificationCodeBtn.enabled = NO;
    }
    
}


#pragma -mark 解绑 确定
- (IBAction)submitAction:(UIButton *)sender {
    // 如果信息填写不完整
    if (![_phoneNumField.text isMobileNumber])
    {
        [self showMessage:CheckMobileMessage delay:2];
    }else if (![_phoneNewFiled.text isMobileNumber])
    {
        [self showMessage:@"新手机号填写格式错误" delay:2];
        
    }else {
        [self submitInterfaceData];
    }
}

- (void)submitInterfaceData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1002" forKey:@"rec_code"];
    [dictParam setValue:_phoneNumField.text forKey:@"rec_userPhone"]; // 旧注册手机号
    [dictParam setValue:_passwordFiled.text forKey:@"rec_pwd"];  // 密码
    [dictParam setValue:_phoneNewFiled.text forKey:@"rec_newUserPhone"]; // 新手机号码
    [dictParam setValue:_VerificationCodeFiled.text forKey:@"rec_verification"]; // 验证码
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        if (error) {
            
        }
        YHLog(@"%@", result);
        YHLog(@"%@", result[@"res_num"]);
        // 提示信息
        [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
        
        if ( [result[@"res_num"] isEqualToString:@"0"]) {  // 成功
            // 跳转到登录
            [self JumpLoginPage];
        }
        return YES;
    }];
}

///  跳转到登录页面
- (void)JumpLoginPage {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.loginOrReg = YES;
    
    
    //    vc.mDict= [NSMutableDictionary dictionary];
    //    //传递参数过去
    //    [vc.mDict setValue:_phoneNewFiled.text forKey:@"phoneNumField"]; // 用户注册手机号
    //    [vc.mDict setValue:_passwordFiled.text forKey:@"passwordFiled"]; // 密码
    YHNavigationController *loginView = [[YHNavigationController alloc] initWithRootViewController:loginVC];
    
    [self presentViewController:loginView animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
