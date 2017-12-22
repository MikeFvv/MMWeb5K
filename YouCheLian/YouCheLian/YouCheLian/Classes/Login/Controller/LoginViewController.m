//
//  LoginViewController.m
//  YouCheLian
//
//  Created by Mike on 15/11/4.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "LoginViewController.h"
#import "SSKeychain.h"
#import <MJExtension.h>
#import "GetPasswordController.h"  // 找回密码

#import "JKCountDownButton.h"
#import <MBProgressHUD.h>

#import "NSString+RegexCategory.h"
#import "RegProtocolWebVC.h"


// 50
#define kMarginHeight kUIScreenHeight * 0.104
// 35
#define kMarginHeight35 kUIScreenHeight * 0.073
// 做适配用
// 头部图bg + 按钮 高度
//#define headButtomHeight (kUIScreenHeight *0.170 + kMarginHeight35)
#define headButtomHeight kMarginHeight35
// 45
#define kMarginHeight45 kUIScreenHeight * 0.093

@interface LoginViewController ()<UITextFieldDelegate, UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;


// === 登录 ===
@property (nonatomic, strong) UITextField *loginAccountField;  // 登录手机号码
@property (nonatomic, strong) UITextField *loginPasswordField;  // 登录密码
@property (nonatomic, strong) UIButton *loginForgetPassword;  // 忘记密码
@property (nonatomic, strong) UIButton *loginBtn;       // 登录按钮
@property (nonatomic, strong) NSDictionary *loginDict;

// === 注册 ===
@property (nonatomic, strong) UITextField *regAccField;   // 注册手机号码
@property (nonatomic, strong) UITextField *regPowField;   // 注册密码
@property (nonatomic, strong) UITextField *regConPowField;  // 注册确认密码
@property (nonatomic, strong) UITextField *regVerCodeField; // 注册验证码

// 获取验证码
@property (nonatomic, strong) NSDictionary *verDict;
@property (nonatomic, strong) JKCountDownButton *getVerBtn;  // 验证码
@property (nonatomic, strong) UIButton *regConBtn;
@property (nonatomic, strong) NSDictionary *regDict;

@property (nonatomic, strong) NSMutableArray *buttonArray;


@property (strong,nonatomic) UIScrollView *scrollView;

// 是否在倒计时当中
@property (nonatomic, assign) BOOL isDownTime;

// 注册协议选择图标
@property (nonatomic, strong) UIButton *iconBtn;
// 注册协议入口
@property (nonatomic, strong) UIButton *textRegBtn;

@end



@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    //  初始化视图
    [self initView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //显示导航栏
    self.navigationController.navigationBar.hidden = NO;
    // 显示tabbar
    
    // 显示之前登录过的账号
    
    NSString *phoneNum = [UserDefaultsTools stringForKey:AccountNumber];
    if (phoneNum.length > 0) {
        _loginAccountField.text = phoneNum;
    }
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}


-(void)setNav {
    // Nav 返回
    self.navigationItem.title=@"登录";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
}


#pragma mark - 登录 接口数据
/// 登录确认
- (void)loginBtnAction {
    
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1008" forKey:@"rec_code"];
    [dictParam setValue:_loginAccountField.text forKey:@"rec_userPhone"];
    [dictParam setValue:_loginPasswordField.text forKey:@"rec_pwd"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [self showLoadingView];
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@" ===== %@", result);
        
        if (error) {
            
        } else {
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                
                // 保存账号  偏好设置
                [UserDefaultsTools setObject:_loginAccountField.text forKey:AccountNumber];

                
                // 密码保存在钥匙串  后台需要验证账号密码用
                NSString *service = [NSBundle mainBundle].bundleIdentifier;  // 获取唯一的字符标识
                
                [SSKeychain setPassword:_loginPasswordField.text forService:service account:_loginAccountField.text];
                
                YHLog(@"账号密码：%@--%@",_loginAccountField.text,_loginPasswordField.text);
                
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
                    
                    // 登录成功后执行 block  通知使用者
                    if (self.loginSuccessBlock) { //执行block
                        self.loginSuccessBlock();
                    }
                    
                    // 后退方法
                    [self backMethod];
                }
            } else {
                [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            }
        }
        [self hidenLoadingView];
        return YES;
    }];
}

// 登录 注册 成功后调用
- (void)backMethod {
    // 关闭Modal 出的控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma -mark 获取短信验证码
/// 获取验证码
- (void)getVerBtnAction {
    
    if (![_regAccField.text isMobileNumber]) {
        [self showMessage:CheckMobileMessage delay:2];
    } else {
        
        // 请求数据
        // 创建一个空字典
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValue:@"1007" forKey:@"rec_code"];
        [dictParam setValue:@"1" forKey:@"rec_type"]; // 1 注册 2更改绑定手机3忘记密码
        [dictParam setValue:_regAccField.text forKey:@"rec_userPhone"];
        //  MD5 加密
        [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
        
        YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
        
        [self showLoadingView];
        [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
            [self hidenLoadingView];
            YHLog(@"验证码结果===%@", result);
            _verDict = result;
            [self showMessage:_verDict[@"res_desc"] delay:2];
            
#pragma mark - 验证码 倒计时
            if ([self.verDict[@"res_num"] isEqualToString:@"0"]){
                
                _getVerBtn.enabled = NO;
                [_getVerBtn startWithSecond:120];
                _getVerBtn.backgroundColor = kLightGrayColor;
                [_getVerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                self.isDownTime = YES;
                
                [_getVerBtn didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                    
                    NSString *title = [NSString stringWithFormat:@"重新发送(%d)",second];
                    return title;
                }];
                
                [_getVerBtn didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                    self.isDownTime = NO;
                    if (self.regAccField.text.length > 0) {
                        countDownButton.enabled = YES;
                        _getVerBtn.backgroundColor = kColorDarkGreen;
                    }
                    
                    [_getVerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    return @"获取验证码";
                }];
            }
            
            
            return YES;
        }];
    }
}

#pragma mark - 注册 接口数据
/// 注册
- (void)registeredBtn {
    
    // 如果信息填写不完整
    if (![_regAccField.text isMobileNumber])
    {
        [self showHint:CheckMobileMessage];
    }
    else if (![_regPowField.text isEqualToString:_regConPowField.text])  // 两次填写的密码是否相同
    {
        [self showHint:PasswordNotConsistent];
    }
    else if (![_regPowField.text passwordCheck])
    {
        [self showPassHint:PasswordCheckMessage];
    }
    else if (!self.iconBtn.selected)   //协议是否同意
    {
        [self showHint:@"请同意优车联协议"];
    }
    else
    {
        // 创建一个空字典
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValue:@"1001" forKey:@"rec_code"];
        [dictParam setValue:_regAccField.text forKey:@"rec_userPhone"];
        [dictParam setValue:_regPowField.text forKey:@"rec_pwd"];
        [dictParam setValue:_regVerCodeField.text forKey:@"rec_verification"];
        
        //  MD5 加密
        [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
        
        
        YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
        [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
            
            
            YHLog(@"%@", result);
            
            _regDict = result;
            //            [self showHint:_regDict[@"res_num"]];
            // 提示信息
            [self showHint:_regDict[@"res_desc"]];
            
            if ( [_regDict[@"res_num"] isEqualToString:@"0"]) {  // 成功
                
                // 赋值
                _loginAccountField.text = _regAccField.text;
                _loginPasswordField.text = _regPowField.text;
                
                // 调用登录接口  直接登录
                [self loginBtnAction];
                
            }
            return YES;
        }];
        
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



#pragma mark - 切换 View 登录/注册
/// 登录、 注册页面切换选择
///
/// @param button <#button description#>
-(void)clickButton:(UIButton *)button
{
    [self hidenKeyboard];
    
    if (button.tag == 1000) {
        [_btn1 setBackgroundImage:[UIImage imageNamed:@"reg_arrow"] forState:UIControlStateNormal];
        [_btn2 setBackgroundImage:[UIImage imageNamed:@"reg_arrow_no"] forState:UIControlStateNormal];
        //        [_loginAccountField becomeFirstResponder];
        
    }
    if (button.tag == 1001) {
        [_btn1 setBackgroundImage:[UIImage imageNamed:@"reg_arrow_no"] forState:UIControlStateNormal];
        [_btn2 setBackgroundImage:[UIImage imageNamed:@"reg_arrow"] forState:UIControlStateNormal];
        //        [_regAccField becomeFirstResponder];
    }
    [self.scrollView setContentOffset:CGPointMake( (button.tag -1000)* kUIScreenWidth, 0) animated:YES];
}

/// 找回密码
- (void)forgetPasswordAction {
    UIStoryboard *strory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GetPasswordController *getPassVC = [strory instantiateViewControllerWithIdentifier:@"GetPasswordController"];
    [self.navigationController pushViewController:getPassVC animated:YES];
}




#pragma mark - 键盘操作
- (void)hidenKeyboard
{   // 点击屏幕键盘消失
    [_loginAccountField resignFirstResponder];
    [_loginPasswordField resignFirstResponder];
    [_regAccField resignFirstResponder];
    [_regPowField resignFirstResponder];
    [_regConPowField resignFirstResponder];
    [_regVerCodeField resignFirstResponder];
    
}

#pragma mark - Field 输入后发生的事件
/// Field 事件
- (void)returnOnKeyboard:(UITextField *)sender
{
    
    
    // 登录 确认按钮
    if (_loginAccountField.text.length > 0 && _loginPasswordField.text.length > 0) {
        _loginBtn.backgroundColor = kColorDarkGreen;
        _loginBtn.enabled = YES;
    }
    if (_loginAccountField.text.length == 0 || _loginPasswordField.text.length == 0) {
        _loginBtn.backgroundColor = kLineBackColor;
        _loginBtn.enabled = NO;
    }
    
    
    // 注册 确认按钮
    if (_regAccField.text.length > 0 && _regPowField.text.length > 0 && _regConPowField.text.length > 0  && _regVerCodeField.text.length > 0 ) {
        _regConBtn.backgroundColor = kColorDarkGreen;
        _regConBtn.enabled = YES;
    }
    if (_regAccField.text.length == 0 || _regPowField.text.length == 0 || _regConPowField.text.length == 0  || _regVerCodeField.text.length == 0 ) {
        _regConBtn.backgroundColor = kLineBackColor;
        _regConBtn.enabled = NO;
    }
    
    
    
    // 注册 验证码
    if (sender.tag == 2000) {
        if (self.isDownTime == YES) {
            return;  // 在计时当中直接返回 不走下面的代码
        }
        
        if (_regAccField.text.length > 0) {
            _getVerBtn.backgroundColor = kColorDarkGreen;
            [_getVerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _getVerBtn.enabled = YES;
        }
        if (_regAccField.text.length == 0) {
            _getVerBtn.backgroundColor = kLineBackColor;
            [_getVerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            _getVerBtn.enabled = NO;
        }
    }
}


#pragma mark - 轻扫手势 右边
//#pragma mark - 轻扫手势 右边
- (void)rightSwipe:(UISwipeGestureRecognizer *)sgr {
    [self hidenKeyboard];
    
    [self.scrollView setContentOffset:CGPointMake( 0 * kUIScreenWidth, 0) animated:YES];
    
    [_btn1 setBackgroundImage:[UIImage imageNamed:@"reg_arrow"] forState:UIControlStateNormal];
    [_btn2 setBackgroundImage:[UIImage imageNamed:@"reg_arrow_no"] forState:UIControlStateNormal];
    //    [_loginAccountField becomeFirstResponder];
    
}
#pragma mark - 轻扫手势 左边
//#pragma mark - 轻扫手势 左边
- (void)leftSwipe:(UISwipeGestureRecognizer *)sgr {
    [self hidenKeyboard];
    
    [_btn1 setBackgroundImage:[UIImage imageNamed:@"reg_arrow_no"] forState:UIControlStateNormal];
    [_btn2 setBackgroundImage:[UIImage imageNamed:@"reg_arrow"] forState:UIControlStateNormal];
    //    [_regAccField becomeFirstResponder];
    
    [self.scrollView setContentOffset:CGPointMake( 1 * kUIScreenWidth, 0) animated:YES];
}




#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _loginAccountField) {
        //        return [_passwordField becomeFirstResponder];
    } else {
        [self hidenKeyboard];
        //        return [_passwordField resignFirstResponder];
    }
    return YES;
}

- (void)cancel {
    // 关闭当初Modal出来的控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - 搭建界面
///  初始化界面
- (void)initView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.buttonArray = [NSMutableArray array];
    
    // 头部图片
    //    UIImageView *headBg = [[UIImageView alloc] init];
    //    headBg.image = [UIImage imageNamed:@"login_bg"];
    //    [self.view addSubview:headBg];
    //
    //    [headBg mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, kUIScreenHeight *0.170));
    //        make.top.mas_equalTo(self.view.mas_top);
    //    }];
    
    // 头部 登录button
    _btn1 = [[UIButton alloc] init];
    [_btn1 setBackgroundImage:[UIImage imageNamed:@"reg_arrow"] forState:UIControlStateNormal];
    [_btn1 setTitle:@"登 录" forState:UIControlStateNormal];
    _btn1.tag = 1000;
    [_btn1 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btn1];
    
    [self.buttonArray addObject:_btn1];
    // 头部 注册button
    _btn2 = [[UIButton alloc] init];
    [_btn2 setBackgroundImage:[UIImage imageNamed:@"reg_arrow_no"] forState:UIControlStateNormal];
    [_btn2 setTitle:@"注 册" forState:UIControlStateNormal];
    _btn2.tag = 1001;
    [_btn2 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn2];
    
    [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kUIScreenWidth/2, kMarginHeight35));
        make.top.mas_equalTo(self.view.mas_top);
    }];
    
    [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kUIScreenWidth/2, kMarginHeight35));
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    [self.buttonArray addObject:_btn2];
    
    
    // 添加 UIScrollView 控件用来切换登录和注册
    NSArray *colorArray = @[[UIColor whiteColor],[UIColor whiteColor]];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, headButtomHeight, kUIScreenWidth, kUIScreenHeight-headButtomHeight - kUINavHeight)];
    _scrollView.delegate = self;
    
    _scrollView.contentSize = CGSizeMake(kUIScreenWidth * colorArray.count, kUIScreenHeight-headButtomHeight- kUINavHeight);
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    
    //给ScrollView添加轻扫手势
    UISwipeGestureRecognizer *leftSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipeGesture.direction=UISwipeGestureRecognizerDirectionLeft;
    [_scrollView addGestureRecognizer:leftSwipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipeGesture.direction=UISwipeGestureRecognizerDirectionRight;
    [_scrollView addGestureRecognizer:rightSwipeGesture];
    
    
    
    for (int i = 0; i < colorArray.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i* kUIScreenWidth, 0, kUIScreenWidth, kUIScreenHeight-headButtomHeight -kUINavHeight)];
        
        view.backgroundColor = [colorArray objectAtIndex:i];
        [_scrollView addSubview:view];
        
        if (i == 0) {
            // 手机号码线
            UIView *ihpone_line = [[UIView alloc] init];
            ihpone_line.backgroundColor = kLineBackColor;
            [view addSubview:ihpone_line];
            
            // 密码线
            UIView *passwode_line = [[UIView alloc] init];
            passwode_line.backgroundColor = kLineBackColor;
            [view addSubview:passwode_line];
            
            [ihpone_line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(view.mas_centerX);
                make.top.equalTo(view.mas_top).with.offset(kMarginHeight45);
                make.size.mas_equalTo(CGSizeMake(280, 1));
            }];
            
            [passwode_line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(view.mas_centerX);
                make.top.equalTo(ihpone_line.mas_bottom).with.offset(kMarginHeight);
                make.size.mas_equalTo(CGSizeMake(280, 1));
            }];
            
            UIImageView *phone_img = [[UIImageView alloc] init];
            phone_img.image = [UIImage imageNamed:@"login_phone_number"];
            [view addSubview:phone_img];
            
            [phone_img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(ihpone_line.mas_top).with.offset(-8);
                make.left.equalTo(ihpone_line.mas_left).with.offset(10);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            
            UILabel *phone_label = [[UILabel alloc] init];
            phone_label.text = @"手机号码";
            [phone_label setFont:YHFont(14, NO)];
            [view addSubview:phone_label];
            
            [phone_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(phone_img.mas_centerY);
                make.left.equalTo(phone_img.mas_right).with.offset(15);
            }];
            
            UIImageView *password_img = [[UIImageView alloc] init];
            password_img.image = [UIImage imageNamed:@"login_password"];
            [view addSubview:password_img];
            
            [password_img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(passwode_line.mas_top).with.offset(-8);
                make.left.equalTo(passwode_line.mas_left).with.offset(10);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            
            UILabel *password_label = [[UILabel alloc] init];
            password_label.text = @"密       码";
            [password_label setFont:YHFont(14, NO)];
            [view addSubview:password_label];
            
            [password_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(password_img.mas_centerY);
                make.left.equalTo(password_img.mas_right).with.offset(15);
            }];
            
            //账号框
            _loginAccountField =[[UITextField alloc] init];
            _loginPasswordField.tag = 1900;
            _loginAccountField.placeholder = @"手机号";
            // 键盘模式
            _loginAccountField.keyboardType=UIKeyboardTypePhonePad;
            _loginAccountField.textColor = [UIColor blackColor];
            _loginAccountField.borderStyle= UITextBorderStyleNone; //外框类型
            _loginAccountField.delegate = self;      // 设置代理 用于实现协议
            _loginAccountField.returnKeyType = UIReturnKeyNext; // 设置键盘按键类型
            _loginAccountField.clearButtonMode = UITextFieldViewModeWhileEditing;    // UITextField 的一件清除按钮是否出现
            _loginAccountField.enablesReturnKeyAutomatically = YES;  // 这里设置为无文字就灰色不可点
            // // 输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容 .
            [_loginAccountField setLeftViewMode:UITextFieldViewModeAlways];  // 一直出现
            
            //密码框
            _loginPasswordField =[[UITextField alloc] init];
            _loginPasswordField.tag = 1901;
            _loginPasswordField.placeholder = @"请输入密码";
            _loginPasswordField.textColor = [UIColor blackColor];
            _loginPasswordField.secureTextEntry = YES;// 是否以密码形式显示
            _loginPasswordField.delegate = self;
            _loginPasswordField.returnKeyType = UIReturnKeyDone;
            _loginPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _loginPasswordField.enablesReturnKeyAutomatically = YES;
            [_loginPasswordField setLeftViewMode:UITextFieldViewModeAlways];
            
            
            [_loginAccountField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingChanged];
            [_loginPasswordField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingChanged];
            
            [view addSubview: _loginAccountField];
            [view addSubview: _loginPasswordField];
            
            [_loginAccountField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(phone_label.mas_centerY);
                make.left.equalTo(phone_label.mas_right).with.offset(15);
                make.size.mas_equalTo(CGSizeMake(175, 22));
            }];
            
            [_loginPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(password_label.mas_centerY);
                make.left.equalTo(password_label.mas_right).with.offset(15);
                make.size.mas_equalTo(CGSizeMake(195, 22));
            }];
            
            // 登录按钮
            _loginBtn = [[UIButton alloc] init];
            
            [_loginBtn setTitle:@"确 认" forState:UIControlStateNormal];
            self.loginBtn.layer.cornerRadius = 5.0;
            
            [_loginBtn setBackgroundColor:kLineBackColor];
            
            [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_loginBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            _loginBtn.titleLabel.font = YHFont(15, NO);;
            [_loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:_loginBtn];
            
            [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(passwode_line.mas_bottom).with.offset(45);
                make.centerX.mas_equalTo(view.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(220, kMarginHeight35));
            }];
            
            
            UIButton *forgetPassword = [[UIButton alloc] init];
            [forgetPassword setTitle:@"忘记密码" forState:UIControlStateNormal];
            [forgetPassword setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [forgetPassword addTarget:self action:@selector(forgetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
            forgetPassword.titleLabel.font = YHFont(12, NO);;
            [view addSubview:forgetPassword];
            
            [forgetPassword mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(view.mas_bottom).with.offset(-15);
                make.centerX.mas_equalTo(view.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(50, 22));
            }];
            
            
            UIView *forgetPassword_line1 = [[UIView alloc] init];
            forgetPassword_line1.backgroundColor = kLineBackColor;
            [view addSubview:forgetPassword_line1];
            
            [forgetPassword_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(forgetPassword.mas_centerY);
                make.right.equalTo(forgetPassword.mas_left).with.offset(-12);
                make.size.mas_equalTo(CGSizeMake(100, 1));
            }];
            
            UIView *forgetPassword_line2 = [[UIView alloc] init];
            forgetPassword_line2.backgroundColor = kLineBackColor;
            [view addSubview:forgetPassword_line2];
            
            [forgetPassword_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(forgetPassword.mas_centerY);
                make.left.equalTo(forgetPassword.mas_right).with.offset(12);
                make.size.mas_equalTo(CGSizeMake(100, 1));
            }];
            
        }
        
        // 注册页面
        if (i == 1) {
            // 手机号码线
            UIView *reg_ihpone_line = [[UIView alloc] init];
            reg_ihpone_line.backgroundColor = kLineBackColor;
            [view addSubview:reg_ihpone_line];
            // 密码线
            UIView *reg_passwode_line = [[UIView alloc] init];
            reg_passwode_line.backgroundColor = kLineBackColor;
            [view addSubview:reg_passwode_line];
            // 确认密码线
            UIView *conPow_line = [[UIView alloc] init];
            conPow_line.backgroundColor = kLineBackColor;
            [view addSubview:conPow_line];
            // 验证码线
            UIView *verCode_line = [[UIView alloc] init];
            verCode_line.backgroundColor = kLineBackColor;
            [view addSubview:verCode_line];
            
            [reg_ihpone_line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(view.mas_centerX);
                make.top.equalTo(view.mas_top).with.offset(kMarginHeight45);
                make.size.mas_equalTo(CGSizeMake(280, 1));
            }];
            
            [reg_passwode_line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(view.mas_centerX);
                make.top.equalTo(reg_ihpone_line.mas_bottom).with.offset(kMarginHeight);
                make.size.mas_equalTo(CGSizeMake(280, 1));
            }];
            
            [conPow_line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(view.mas_centerX);
                make.top.equalTo(reg_passwode_line.mas_bottom).with.offset(kMarginHeight);
                make.size.mas_equalTo(CGSizeMake(280, 1));
            }];
            
            [verCode_line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(view.mas_centerX);
                make.top.equalTo(conPow_line.mas_bottom).with.offset(kMarginHeight);
                make.size.mas_equalTo(CGSizeMake(280, 1));
            }];
            
            
            UIImageView *reg_phone_img = [[UIImageView alloc] init];
            reg_phone_img.image = [UIImage imageNamed:@"login_phone_number"];
            [view addSubview:reg_phone_img];
            
            [reg_phone_img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(reg_ihpone_line.mas_top).with.offset(-8);
                make.left.equalTo(reg_ihpone_line.mas_left).with.offset(10);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            
            UILabel *reg_phone_label = [[UILabel alloc] init];
            reg_phone_label.text = @"手机号码";
            [reg_phone_label setFont:YHFont(14, NO)];
            [view addSubview:reg_phone_label];
            
            [reg_phone_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(reg_phone_img.mas_centerY);
                make.left.equalTo(reg_phone_img.mas_right).with.offset(15);
            }];
            
            
            UIImageView *reg_password_img = [[UIImageView alloc] init];
            reg_password_img.image = [UIImage imageNamed:@"login_password"];
            [view addSubview:reg_password_img];
            
            [reg_password_img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(reg_passwode_line.mas_top).with.offset(-8);
                make.left.equalTo(reg_passwode_line.mas_left).with.offset(10);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            
            UILabel *reg_password_label = [[UILabel alloc] init];
            reg_password_label.text = @"密       码";
            [reg_password_label setFont:YHFont(14, NO)];
            [view addSubview:reg_password_label];
            
            [reg_password_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(reg_password_img.mas_centerY);
                make.left.equalTo(reg_password_img.mas_right).with.offset(15);
            }];
            
            UIImageView *conPow_img = [[UIImageView alloc] init];
            conPow_img.image = [UIImage imageNamed:@"reg_confirm_ password"];
            [view addSubview:conPow_img];
            
            [conPow_img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(conPow_line.mas_top).with.offset(-8);
                make.left.equalTo(conPow_line.mas_left).with.offset(10);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            
            UILabel *conPow_label = [[UILabel alloc] init];
            conPow_label.text = @"确认密码";
            [conPow_label setFont:YHFont(14, NO)];
            [view addSubview:conPow_label];
            
            [conPow_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(conPow_img.mas_centerY);
                make.left.equalTo(conPow_img.mas_right).with.offset(15);
            }];
            
            
            // 获取验证码 button
            _getVerBtn = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
            
            [_getVerBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            _getVerBtn.backgroundColor = kLightGrayColor;
            [_getVerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            _getVerBtn.titleLabel.font = YHFont(12, NO);;
            _getVerBtn.enabled = NO;
            _getVerBtn.layer.cornerRadius = 5;
            [_getVerBtn addTarget:self action:@selector(getVerBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:_getVerBtn];
            
            [_getVerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(verCode_line.mas_top).with.offset(-3);
                make.right.equalTo(verCode_line.mas_right).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(90, 30));
            }];
            
            
            //账号框
            _regAccField =[[UITextField alloc] init];
            _regAccField.placeholder = @"手机号";
            // 键盘模式
            _regAccField.keyboardType=UIKeyboardTypePhonePad;
            _regAccField.textColor = [UIColor blackColor];
            _regAccField.tag = 2000;
            _regAccField.borderStyle= UITextBorderStyleNone; //外框类型
            _regAccField.delegate = self;      // 设置代理 用于实现协议
            _regAccField.returnKeyType = UIReturnKeyNext; // 设置键盘按键类型
            _regAccField.clearButtonMode = UITextFieldViewModeWhileEditing;    // UITextField 的一件清除按钮是否出现
            _regAccField.enablesReturnKeyAutomatically = YES;  // 这里设置为无文字就灰色不可点
            // // 输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容 .
            [_regAccField setLeftViewMode:UITextFieldViewModeAlways];  // 一直出现
            
            //密码框
            _regPowField =[[UITextField alloc] init];
            _regPowField.placeholder = @"请输入密码";
            _regPowField.textColor = [UIColor blackColor];
            _regPowField.tag = 2001;
            _regPowField.secureTextEntry = YES;// 是否以密码形式显示
            _regPowField.delegate = self;
            _regPowField.returnKeyType = UIReturnKeyDone;
            _regPowField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _regPowField.enablesReturnKeyAutomatically = YES;
            [_regPowField setLeftViewMode:UITextFieldViewModeAlways];
            
            // 确认密码框
            _regConPowField =[[UITextField alloc] init];
            _regConPowField.placeholder = @"确认密码";
            _regConPowField.textColor = [UIColor blackColor];
            _regConPowField.tag = 2002;
            _regConPowField.secureTextEntry = YES; // 是否以密码形式显示
            _regConPowField.delegate = self;
            _regConPowField.returnKeyType = UIReturnKeyDone;
            _regConPowField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _regConPowField.enablesReturnKeyAutomatically = YES;
            [_regConPowField setLeftViewMode:UITextFieldViewModeAlways];
            
            // 验证码
            _regVerCodeField =[[UITextField alloc] init];
            _regVerCodeField.placeholder = @"验证码";
            // 键盘模式
            _regVerCodeField.keyboardType=UIKeyboardTypeNumberPad;
            _regVerCodeField.tag = 2003;
            _regVerCodeField.textColor = [UIColor blackColor];
            _regVerCodeField.borderStyle= UITextBorderStyleNone; //外框类型
            _regVerCodeField.delegate = self;      // 设置代理 用于实现协议
            _regVerCodeField.returnKeyType = UIReturnKeyNext; // 设置键盘按键类型
            _regVerCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;    // UITextField 的一件清除按钮是否出现
            _regVerCodeField.enablesReturnKeyAutomatically = YES;  // 这里设置为无文字就灰色不可点
            // // 输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容 .
            [_regVerCodeField setLeftViewMode:UITextFieldViewModeAlways];  // 一直出现
            
            
            [_regAccField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingChanged];
            [_regPowField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingChanged];
            [_regConPowField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingChanged];
            [_regVerCodeField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingChanged];
            
            [view addSubview: _regAccField];
            [view addSubview: _regPowField];
            [view addSubview: _regConPowField];
            [view addSubview: _regVerCodeField];
            
            [_regAccField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(reg_phone_label.mas_centerY);
                make.left.equalTo(reg_phone_label.mas_right).with.offset(15);
                make.size.mas_equalTo(CGSizeMake(175, 22));
            }];
            
            [_regPowField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(reg_password_label.mas_centerY);
                make.left.equalTo(reg_password_label.mas_right).with.offset(15);
                make.size.mas_equalTo(CGSizeMake(195, 22));
            }];
            
            [_regConPowField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(conPow_label.mas_centerY);
                make.left.equalTo(conPow_label.mas_right).with.offset(15);
                make.size.mas_equalTo(CGSizeMake(175, 22));
            }];
            
            [_regVerCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_getVerBtn.mas_centerY);
                make.right.equalTo(_getVerBtn.mas_left).with.offset(-5);
                make.size.mas_equalTo(CGSizeMake(130, 22));
            }];
            
            // 注册确认按钮
            _regConBtn = [[UIButton alloc] init];
            _regConBtn.layer.cornerRadius = 5.0;
            
            [_regConBtn setBackgroundColor:kLineBackColor];
            
            [_regConBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_regConBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [_regConBtn setTitle:@"确 认" forState:UIControlStateNormal];
            _regConBtn.titleLabel.font = YHFont(15, NO);
            [_regConBtn addTarget:self action:@selector(registeredBtn) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:_regConBtn];
            
            [_regConBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(verCode_line.mas_bottom).with.offset(kMarginHeight35);
                make.centerX.mas_equalTo(view.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(220, kMarginHeight35));
            }];
            
            
            /********* 注册协议 *********/
            _iconBtn = [[UIButton alloc] init];
            [_iconBtn setBackgroundImage:[UIImage imageNamed:@"me_checkBtn"] forState:UIControlStateNormal];
            [_iconBtn setBackgroundImage:[UIImage imageNamed:@"me_checkBtn_ok"] forState:UIControlStateSelected];
            [_iconBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:_iconBtn];
            
            
            UILabel *agreeLabel = [[UILabel alloc] init];
            agreeLabel.textColor = [UIColor lightGrayColor];
            agreeLabel.text = @"我已阅读并同意";
            agreeLabel.font = YHFont(12, NO);
            [view addSubview:agreeLabel];
            
            
            _textRegBtn = [[UIButton alloc] init];
            _textRegBtn.titleLabel.font = YHFont(12, NO);
            [_textRegBtn setTitleColor:kGlobalColorGreen forState:UIControlStateNormal];
            [_textRegBtn addTarget:self action:@selector(regProtocolAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [_textRegBtn setTitle:@"《优车联用户协议》" forState:UIControlStateNormal];
            [view addSubview:_textRegBtn];
            
            
            [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(verCode_line.mas_top).with.offset(8);
                make.left.mas_equalTo(verCode_line.mas_left);
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
            
            [agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_iconBtn.mas_centerY);
                make.left.mas_equalTo(_iconBtn.mas_right).with.offset(5);
            }];
            
            [_textRegBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_iconBtn.mas_centerY);
                make.left.mas_equalTo(agreeLabel.mas_right);
                make.size.mas_equalTo(CGSizeMake(120, 20));
            }];
        }
        
        
    }
    // 添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    [self.view addSubview:_scrollView];
    
    //初次设定button，默认第一个按钮为选中状态
    if (_loginOrReg) {
        [self clickButton:(UIButton *)self.buttonArray[0]];
    } else {
        [self clickButton:(UIButton *)self.buttonArray[1]];
    }
}

#pragma mark - 注册协议 跳转
- (void)regProtocolAction:(UIButton *)button {
    
    RegProtocolWebVC *webVC = [[RegProtocolWebVC alloc] init];
    
    [self.navigationController pushViewController:webVC animated:YES];
}


///  注册用户协议 勾选
- (void)checkBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
