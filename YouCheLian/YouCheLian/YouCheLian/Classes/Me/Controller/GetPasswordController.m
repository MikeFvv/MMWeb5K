//
//  SetPasswordController.m
//  YouCheLian
//
//  Created by Mike on 15/11/23.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "GetPasswordController.h"
#import "JKCountDownButton.h"

#import "LoginViewController.h"
#import "YHNavigationController.h"
#import "NSString+RegexCategory.h"

@interface GetPasswordController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;
@property (weak, nonatomic) IBOutlet UITextField *passwordFiled;
@property (weak, nonatomic) IBOutlet UITextField *conPasswordFiled;
@property (weak, nonatomic) IBOutlet UITextField *VerificationCodeFiled;

@property (weak, nonatomic) IBOutlet JKCountDownButton *getVerificationCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

// 是否在倒计时当中
@property (nonatomic, assign) BOOL isDownTime;

@end

@implementation GetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView {
    self.title = @"找回密码";

    // 键盘模式
    _phoneNumField.keyboardType=UIKeyboardTypePhonePad;
    _VerificationCodeFiled.keyboardType = UIKeyboardTypeNumberPad;
    
    _getVerificationCodeBtn.layer.cornerRadius = 5.0;
    _getVerificationCodeBtn.backgroundColor = kLightGrayColor;
    _getVerificationCodeBtn.enabled = NO;
    
    _submitBtn.layer.cornerRadius = 5.0;
    _submitBtn.backgroundColor = kLightGrayColor;
    _submitBtn.tintColor = [UIColor whiteColor];
    _submitBtn.enabled = NO;
    
    
    // 添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
}


#pragma mark - 键盘操作 点击屏幕键盘消失
- (void)hidenKeyboard
{   // 点击屏幕键盘消失
    [_phoneNumField resignFirstResponder];
    [_passwordFiled resignFirstResponder];
    [_conPasswordFiled resignFirstResponder];
    [_VerificationCodeFiled resignFirstResponder];
    
}


#pragma -mark 修改密码 确认
- (IBAction)submitAction:(UIButton *)sender {
    // 如果信息填写不完整
    if (![_phoneNumField.text isMobileNumber])
    {
        [self showMessage:CheckMobileMessage delay:2];

    }else if (![_passwordFiled.text passwordCheck])
    {
        [self showPassHint:PasswordCheckMessage];
        
    }else if (![_passwordFiled.text isEqualToString:_conPasswordFiled.text])  // 两次填写的密码是否相同
    {
        [self showMessage:PasswordNotConsistent delay:2];
    }else
    {
        [self submitInterfaceData];
    }
}

- (void)submitInterfaceData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1009" forKey:@"rec_code"];
    [dictParam setValue:_phoneNumField.text forKey:@"rec_userPhone"]; // 用户注册手机号
    [dictParam setValue:_passwordFiled.text forKey:@"rec_pwd"];  // 密码
    [dictParam setValue:_VerificationCodeFiled.text forKey:@"rec_verification"]; // 验证码
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    [self showLoadingView];
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        [self hidenLoadingView];
        
        if (error) {
            
        } else {
            YHLog(@"%@", result);
            YHLog(@"%@", result[@"res_num"]);
            // 提示信息
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                // 跳转到登录
                [self backLastPage];
            }
        }
        
        return YES;
    }];
}

///  返回到登录页面
- (void)backLastPage {
    // 将栈顶的控制器移除
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma -mark 获取短信验证码
/// 注册 获取短信验证码
- (IBAction)getVerificationCodeAction:(JKCountDownButton *)sender {
    
    if (![_phoneNumField.text isMobileNumber]) {
        [self showMessage:CheckMobileMessage delay:2];
    } else {
        //获取验证码  给个提示
        [self showLoadingView];
        [self VerificationCodeInterfaceData];
    }
}

///  验证码接口
- (void)VerificationCodeInterfaceData {
    // 请求数据
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1007" forKey:@"rec_code"];
    [dictParam setValue:@"3" forKey:@"rec_type"]; // 1 注册 2更改绑定手机3忘记密码
    [dictParam setValue:_phoneNumField.text forKey:@"rec_userPhone"];
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@",  [YHFunction dictionaryToJson:dictParam]) ;
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        [self hidenLoadingView];
        YHLog(@"%@", result);
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
        return YES;
    }];
}

/// Field 事件
- (IBAction)returnOnkeyboard:(UITextField *)sender {
    
    // 确认按钮状态 转换
    if (_phoneNumField.text.length > 0 && _passwordFiled.text.length > 0 && _conPasswordFiled.text.length > 0  && _VerificationCodeFiled.text.length > 0 ) {
        _submitBtn.backgroundColor = kColorDarkGreen;
        _submitBtn.enabled = YES;
    }
    if (_phoneNumField.text.length == 0 || _passwordFiled.text.length == 0 || _conPasswordFiled.text.length == 0  || _VerificationCodeFiled.text.length == 0 ) {
        _submitBtn.backgroundColor = kLightGrayColor;
        _submitBtn.enabled = NO;
    }
    
    
    if (self.isDownTime == YES) {
        return;  // 在计时当中直接返回 不走下面的代码
    }
    
    // 验证码 状态转换
    if (_phoneNumField.text.length > 0) {
        _getVerificationCodeBtn.backgroundColor = kColorDarkGreen;
        _getVerificationCodeBtn.enabled = YES;
    }
    
    if (_phoneNumField.text.length == 0) {
        _getVerificationCodeBtn.backgroundColor = kLightGrayColor;
        _getVerificationCodeBtn.enabled = NO;
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




