//
//  NewAddAddressController.m
//  YouCheLian
//
//  Created by Mike on 15/12/2.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "NewAddAddressController.h"
#import "CityOneModel.h"
#import "CityTwoModel.h"
#import "CityThreeModel.h"
// IQDropDownTextField
#import "YHPickerViewController.h"
#import <IQKeyboardManager.h>
#import "UITextView+Select.h"
#import "NSString+RegexCategory.h"
#import "ReceivingAddressModel.h"

#define kEdgeWidth 15
#define kMarginWidth100 100
#define kMarginWidth30 30
#define kRowHeight 44

// 地址字符数
#define AddresMY_MAX 60

@interface NewAddAddressController ()<YHPickerViewControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate, UITextViewDelegate>


@property (strong, nonatomic) UITextField *nameField;
@property (strong, nonatomic) UITextField *phoneField;

@property (strong, nonatomic) UIButton *cityTextBtn;
@property (strong, nonatomic) UITextView *addressTextView;
@property (strong, nonatomic) UITextField *zipCodeField;

@property (strong, nonatomic) UIButton *defaultIconBtn;


@property (nonatomic, strong) NSArray *cityArray;

@property (nonatomic, copy) NSString *addressId;

@property (nonatomic, assign) NSInteger row1;
@property (nonatomic, assign) NSInteger row2;
@property (nonatomic, assign) NSInteger row3;

// 省份Id
@property (nonatomic, copy) NSString *provinceid;
// 城市Id
@property (nonatomic, copy) NSString *cityid;
// 区域Id
@property (nonatomic, copy) NSString *areaid;

@end

@implementation NewAddAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self initView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    [self setModel:_model];
    
    if(self.isNewAdd == 0) {
        self.row1 = -1;
        self.row2 = -1;
        self.row3 = -1;
    }
}

-(void)setNav {
    
}


/// 设置默认地址
- (void)setDefaultAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    //    _defaultIconBtn.selected = NO;
}


#pragma mark - 删除 地址
- (void)deleteeBtnAction:(UIButton *)sender {
    
    [self deleteData];
}

///
- (void)deleteData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1036" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; // 用户注册手机号
    [dictParam setValue:self.model.ID.stringValue forKey:@"rec_id"]; // 需删除地址ID
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    // 开始显示加载图标
    [self showLoadingView];
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        // 隐藏加载图标
        [self hidenLoadingView];
        if (error) {
            
        } else {
            YHLog(@"%@", result);
            // 提示信息
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            
            if ( [result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                // 将栈顶的控制器移除
                if (self.addressSuccessBlock) {
                    self.addressSuccessBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        return YES;
    }];
}

#pragma mark -  新增保存 修改地址
///  新增保存
- (void)addOrUpdateSaveBtnAction:(UIButton *)btn {
    YHLog(@"新增保存");
    // 如果信息填写不完整
    if([self.nameField.text isEqualToString:@""])
    {
        
        [self showMessage:@"请填写收货人姓名" delay:1.0];
        
    }else if (self.nameField.text.length >= 12 )
    {
        [self showMessage:@"姓名字符过长" delay:1.0];
        
    }else if([self.phoneField.text isEqualToString:@""])
    {
        
        [self showMessage:@"请填写手机号" delay:1.0];
        
    }else if (self.row1 == -1 || self.row2 == -1 || self.row3 == -1)
    {
        
        [self showMessage:@"请选择地区" delay:1.0];
        
    }else if([self.addressTextView.text isEqualToString:@""])
    {
        
        [self showMessage:@"请填写详细地址" delay:1.0];
        
    }else if (![self.phoneField.text isMobileNumber])
    {
        [self showMessage:CheckMobileMessage delay:2];
    }else if (self.addressTextView.text.length > AddresMY_MAX)  // 地址限制 60个 下面有代码方法
    {
        [self showMessage:@"收货地址过长" delay:1.0];
        
    }else if([self.zipCodeField.text isEqualToString:@""])
    {
        
        [self showMessage:@"请填写邮编" delay:1.0];
        
    }else if (![self.zipCodeField.text isValidPostalcode])  // 是否为邮编
    {
        [self showMessage:@"邮编不正确" delay:1.0];
    }else
    {
        [self saveData];
    }
}


///  新增 更改 保存
- (void)saveData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1013" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; // 用户注册手机号
    
    NSString *isNewAddStr = self.isNewAdd == 0 ? @"0" : self.addressId;
    [dictParam setValue:isNewAddStr forKey:@"rec_id"]; // Id=0为新增，如果id不为0为修改
    
    if (self.isNewAdd == 0) {
        CityOneModel *model1 = self.cityArray[self.row1];
        CityTwoModel *model2 = model1.citylist[self.row2];
        CityThreeModel *model3 = model2.arealist[self.row3];
        [dictParam setValue:model1.pId forKey:@"Rec_provinceid"]; // 省份Id
        [dictParam setValue:model2.cId forKey:@"Rec_cityid"]; // 城市Id
        [dictParam setValue:model3.aId forKey:@"Rec_areaid"]; // 区域Id
    } else {
        [dictParam setValue:self.provinceid forKey:@"Rec_provinceid"]; // 省份Id
        [dictParam setValue:self.cityid forKey:@"Rec_cityid"]; // 城市Id
        [dictParam setValue:self.areaid forKey:@"Rec_areaid"]; // 区域Id
    }
    
    //    [dictParam setValue:model1.pId forKey:@"Rec_provinceid"]; // 省份Id
    //    [dictParam setValue:model2.cId forKey:@"Rec_cityid"]; // 城市Id
    //    [dictParam setValue:model3.aId forKey:@"Rec_areaid"]; // 区域Id
    
    [dictParam setValue:self.nameField.text forKey:@"Rec_username"]; // 收货人姓名
    [dictParam setValue:self.phoneField.text forKey:@"rec_newUserPhone"]; // 收货人手机号码
    [dictParam setValue:self.addressTextView.text forKey:@"rec_address"]; // 收货人地址
    
    NSString *isDefault = _defaultIconBtn.selected == NO ? @"0" : @"1";
    [dictParam setValue:isDefault forKey:@"rec_isDefault"];  // 是否为默认地址0=不是，1=默认
    [dictParam setValue:self.zipCodeField.text forKey:@"Rec_zipcode"];  // 邮编
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    // 开始显示加载图标
    [self showLoadingView];
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        // 隐藏加载图标
        [self hidenLoadingView];
        if (error) {
            
        } else {
            YHLog(@"%@", result);
            // 提示信息
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            
            if ( [result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                // 跳转到登录
                // 将栈顶的控制器移除
                if (self.addressSuccessBlock) {
                    self.addressSuccessBlock();
                }
                // 将栈顶的控制器移除
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        
        return YES;
    }];
}


#pragma mark - 更新地址 编辑赋值
- (void)setModel:(ReceivingAddressModel *)model {
    _model = model;
    self.nameField.text = model.name;
    self.phoneField.text = model.linkPhone;
    
    NSString *cityName;
    if (![model.areaid isEqualToString:@""]) {
        cityName = [self getCity:model.areaid];
    } else if (![model.cityid isEqualToString:@""]) {
        cityName = [self getCity:model.cityid];
    } else if (![model.cityid isEqualToString:@""]) {
        cityName = [self getCity:model.provinceid];
    } else {
        
    }
    
    _provinceid = model.provinceid;
    _cityid = model.cityid;
    _areaid = model.areaid;
    _addressId = model.ID.stringValue;
    
    [self.cityTextBtn setTitle:cityName forState:UIControlStateNormal];
    [_cityTextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.addressTextView.text = model.address;
    self.zipCodeField.text = model.zipcode;
    BOOL isDefault =  model.isDefault.integerValue == 0 ? NO : YES;
    [self.defaultIconBtn setSelected:isDefault];
    
}







/// 获取省市名
///
///  @param areaId 省市id
///  @return   可以返回3级省市名称
- (NSString *)getCity:(NSString *)areaId {
    // 从文件中加载数组
    NSArray *appArray = [YHFunction arrayWithString:@"citydata.plist"];
    // 创建数据用来装模型数据
    NSMutableArray *apps = [NSMutableArray array];
    for (NSDictionary *dict in appArray) {
        // 将字典转化模型
        CityOneModel *model = [CityOneModel mj_objectWithKeyValues:dict];
        [apps addObject:model];
    }
    
    // 一级一级遍历下去， 遍历到了把上一级拼接一起返回
    for (CityOneModel *oneModel in apps) {
        if ([oneModel.pId isEqualToString:areaId]) {
            return oneModel.provinceName;
        }
        for (CityTwoModel *twoModel in oneModel.citylist) {
            if ([twoModel.cId isEqualToString:areaId]) {
                return [NSString stringWithFormat:@"%@%@",oneModel.provinceName,twoModel.cityName];
            }
            for (CityThreeModel *threeModel in twoModel.arealist) {
                if ([threeModel.aId isEqualToString:areaId]) {
                    return [NSString stringWithFormat:@"%@%@%@",oneModel.provinceName, twoModel.cityName, threeModel.areaName];
                }
            }
        }
    }
    return @"";
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

{//string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if (self.nameField == textField)//判断是否时我们想要限定的那个输入框
    {
        if ([string isEqualToString:@"\n"])//按会车可以改变
        {
            return YES;
        }
        
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];//得到输入框的内容
        
        if ([toBeString length] >= 10) {//如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:9];
            
            return NO;
        }
    }
    return YES;
}

#pragma mark - 选择 省市区地址
// 省市区地址
- (void)cityBtnAction:(UIButton *)sender {
    [self viewTapped];
    NSMutableArray *cityData = [CityOneModel mj_objectArrayWithFilename:@"citydata.plist"];
    _cityArray = cityData;
    
    YHPickerViewController *vc = [[YHPickerViewController alloc] init];
    vc.dataArray = _cityArray;
    vc.delegate = self;
    [vc show];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ((textView.text.length - range.length + text.length) > AddresMY_MAX)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"输入的自字符数不能超过60"
                                                       delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        NSString *substring = [text substringToIndex:AddresMY_MAX - (textView.text.length - range.length)];
        NSMutableString *lastString = [textView.text mutableCopy];
        [lastString replaceCharactersInRange:range withString:substring];
        textView.text = [lastString copy];
        return NO;
    }
    else
    {
        return YES;
    }
}




-(void)viewTapped
{
    // 键盘收回
    [self.nameField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.addressTextView resignFirstResponder];
    [self.zipCodeField resignFirstResponder];
}


- (IBAction)endFieldAction:(UITextField *)sender {
    [sender resignFirstResponder];
    [IQKeyboardManager sharedManager].enable = NO;
}





#pragma mark - 省市区 Picker 代理
-(void)pickerViewControllerDidClickSureBtnWithRow1:(NSInteger)row1 andRow2:(NSInteger)row2 andRow3:(NSInteger)row3 {
    
    self.row1 = row1;
    self.row2 = row2;
    self.row3 = row3;
    
    CityOneModel *model1 = self.cityArray[self.row1];
    CityTwoModel *model2 = model1.citylist[self.row2];
    CityThreeModel *model3 = model2.arealist[self.row3];
    
    NSString *str = nil;
    if([model1.provinceName isEqualToString:model2.cityName] && [model1.provinceName isEqualToString:model3.areaName]) {
        str = [NSString stringWithFormat:@"%@",model1.provinceName];
    }else if ([model1.provinceName isEqualToString:model2.cityName]) {
        str = [NSString stringWithFormat:@"%@%@",model1.provinceName,model3.areaName];
    }else{
        str = [NSString stringWithFormat:@"%@%@%@",model1.provinceName,model2.cityName,model3.areaName];
    }
    
    //    _cityTextBtn.titleLabel.text = str;
    [_cityTextBtn setTitle:str forState:UIControlStateNormal];
    [_cityTextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    _cityTextBtn.titleLabel.textColor = [UIColor blackColor];
}




-(void)initView {
    
    /******** 0 收货人姓名 *********/
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(258);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"收货人姓名";
    nameLabel.textColor = kGlobalFontColor;
    nameLabel.font = YHFont(14, NO);;
    [self.view addSubview:nameLabel];
    
    _nameField = [[UITextField alloc] init];
    _nameField.placeholder = @"姓名";
    _nameField.clearButtonMode = UITextFieldViewModeAlways;
    _nameField.borderStyle = UITextBorderStyleNone;
    _nameField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_nameField];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = kLineBackColor;
    [self.view addSubview:lineView1];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_top).with.offset(13);
        make.left.mas_equalTo(bgView.mas_left).with.offset(kEdgeWidth);
    }];
    
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel.mas_centerY);
        make.left.mas_equalTo(bgView.mas_left).with.offset(kMarginWidth100);
        make.right.mas_equalTo(bgView.mas_right).with.offset(-kEdgeWidth);
        make.height.mas_equalTo(kMarginWidth30);
    }];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_top).with.offset(kRowHeight);
        make.left.mas_equalTo(bgView.mas_left);
        make.right.mas_equalTo(bgView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    
    /******** 1 手机号 *********/
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = @"手机号";
    phoneLabel.textColor = kGlobalFontColor;
    phoneLabel.font = YHFont(14, NO);;
    [self.view addSubview:phoneLabel];
    
    _phoneField = [[UITextField alloc] init];
    _phoneField.placeholder = @"手机号";
    // 键盘模式
    _phoneField.keyboardType=UIKeyboardTypePhonePad;
    _phoneField.clearButtonMode = UITextFieldViewModeAlways;
    _phoneField.borderStyle = UITextBorderStyleNone;
    _phoneField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_phoneField];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = kLineBackColor;
    [self.view addSubview:lineView2];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView1.mas_top).with.offset(13);
        make.left.mas_equalTo(bgView.mas_left).with.offset(kEdgeWidth);
    }];
    
    [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(phoneLabel.mas_centerY);
        make.left.mas_equalTo(bgView.mas_left).with.offset(kMarginWidth100);
        make.right.mas_equalTo(bgView.mas_right).with.offset(-kEdgeWidth);
        make.height.mas_equalTo(kMarginWidth30);
    }];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView1.mas_top).with.offset(kRowHeight);
        make.left.mas_equalTo(bgView.mas_left);
        make.right.mas_equalTo(bgView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    /******** 2 省、市、区 *********/
    UILabel *cityLabel = [[UILabel alloc] init];
    cityLabel.text = @"省、市、区";
    cityLabel.textColor = kGlobalFontColor;
    cityLabel.font = YHFont(14, NO);;
    [bgView addSubview:cityLabel];
    
    _cityTextBtn = [[UIButton alloc] init];
    [_cityTextBtn setTitle:@"省、市、区" forState:UIControlStateNormal];
    [_cityTextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_cityTextBtn addTarget:self action:@selector(cityBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _cityTextBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _cityTextBtn.backgroundColor = [UIColor clearColor];
    [bgView addSubview:_cityTextBtn];
    
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = kLineBackColor;
    [bgView addSubview:lineView3];
    
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView2.mas_top).with.offset(13);
        make.left.mas_equalTo(bgView.mas_left).with.offset(kEdgeWidth);
    }];
    
    [_cityTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cityLabel.mas_centerY);
        make.left.mas_equalTo(bgView.mas_left).with.offset(kMarginWidth100);
        make.right.mas_equalTo(bgView.mas_right).with.offset(-kEdgeWidth);
        make.height.mas_equalTo(kMarginWidth30);
    }];
    
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView2.mas_top).with.offset(kRowHeight);
        make.left.mas_equalTo(bgView.mas_left);
        make.right.mas_equalTo(bgView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    /******** 3 详细地址*********/
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"详细地址";
    addressLabel.textColor = kGlobalFontColor;
    addressLabel.font = YHFont(14, NO);;
    [bgView addSubview:addressLabel];
    
    _addressTextView = [[UITextView alloc] init];
    //    _addressTextView.placeholder = @"手机号";
    _addressTextView.backgroundColor = [UIColor redColor];
    _addressTextView.font = YHFont(14, NO);
    
    _addressTextView.layer.cornerRadius = 5;
    _addressTextView.backgroundColor = [UIColor colorWithRed:0.969  green:0.973  blue:0.976 alpha:1];
    [bgView addSubview:_addressTextView];
    
    UIView *lineView4 = [[UIView alloc] init];
    lineView4.backgroundColor = kLineBackColor;
    [bgView addSubview:lineView4];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView3.mas_top).with.offset(13);
        make.left.mas_equalTo(bgView.mas_left).with.offset(kEdgeWidth);
    }];
    
    [_addressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addressLabel.mas_top).with.offset(-5);
        make.left.mas_equalTo(bgView.mas_left).with.offset(kMarginWidth100);
        make.right.mas_equalTo(bgView.mas_right).with.offset(-kEdgeWidth);
        make.height.mas_equalTo(68);
    }];
    
    [lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView3.mas_top).with.offset(kRowHeight+38);
        make.left.mas_equalTo(bgView.mas_left);
        make.right.mas_equalTo(bgView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    /******** 4 邮编*********/
    UILabel *zipCodeLabel = [[UILabel alloc] init];
    zipCodeLabel.text = @"邮编";
    zipCodeLabel.textColor = kGlobalFontColor;
    zipCodeLabel.font = YHFont(14, NO);;
    [bgView addSubview:zipCodeLabel];
    
    _zipCodeField = [[UITextField alloc] init];
    _zipCodeField.placeholder = @"邮编";
    // 键盘模式
    _zipCodeField.keyboardType=UIKeyboardTypeNumberPad;
    // 清除按钮 x
    _zipCodeField.clearButtonMode = UITextFieldViewModeAlways;
    _zipCodeField.borderStyle = UITextBorderStyleNone;
    _zipCodeField.backgroundColor = [UIColor clearColor];
    [bgView addSubview:_zipCodeField];
    
    UIView *lineView5 = [[UIView alloc] init];
    lineView5.backgroundColor = kLineBackColor;
    [bgView addSubview:lineView5];
    
    [zipCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView4.mas_top).with.offset(13);
        make.left.mas_equalTo(bgView.mas_left).with.offset(kEdgeWidth);
    }];
    
    [_zipCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(zipCodeLabel.mas_centerY);
        make.left.mas_equalTo(bgView.mas_left).with.offset(kMarginWidth100);
        make.right.mas_equalTo(bgView.mas_right).with.offset(-kEdgeWidth);
        make.height.mas_equalTo(kMarginWidth30);
    }];
    
    [lineView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView4.mas_top).with.offset(kRowHeight);
        make.left.mas_equalTo(bgView.mas_left);
        make.right.mas_equalTo(bgView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    
    _defaultIconBtn = [[UIButton alloc] init];
    [_defaultIconBtn setImage:[UIImage imageNamed:@"me_checkBtn"] forState:UIControlStateNormal];
    [_defaultIconBtn setImage:[UIImage imageNamed:@"me_checkBtn_ok"] forState:UIControlStateSelected];

    
    [_defaultIconBtn setTitle:@"设为默认地址" forState:UIControlStateNormal];
    [_defaultIconBtn setTitleColor:kColorDarkGreen forState:UIControlStateNormal];
    _defaultIconBtn.titleLabel.font = YHFont(14, NO);;
    _defaultIconBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _defaultIconBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    _defaultIconBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [_defaultIconBtn addTarget:self action:@selector(setDefaultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_defaultIconBtn];
    
    [_defaultIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_bottom).with.offset(5);
        make.left.mas_equalTo(bgView.mas_left);
        make.right.mas_equalTo(bgView.mas_right);
        make.height.mas_equalTo(30);
    }];
    
    /************ View底部 ************/
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kUIScreenHeight-49 - kUINavHeight, kUIScreenWidth, 49)];
    bottomView.backgroundColor = kNavColor;
    [self.view addSubview:bottomView];
    
    if (self.isNewAdd == 0) {
        /**** 新增保存地址 ****/
        UIButton *saveBtn = [[UIButton alloc] init];
        [saveBtn setTitle:@"保存地址" forState:UIControlStateNormal];
        saveBtn.backgroundColor = kColorDarkGreen;
        
        [saveBtn addTarget:self action:@selector(addOrUpdateSaveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        saveBtn.layer.cornerRadius = 5;
        [bottomView addSubview:saveBtn];
        
        [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bottomView.mas_centerX);
            make.centerY.mas_equalTo(bottomView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(kUIScreenWidth/2, 35));
        }];
    } else {
        
        /**** 删除 - 修改 ****/
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setTitle:@"删除地址" forState:UIControlStateNormal];
        deleteBtn.backgroundColor = [UIColor clearColor];
        [deleteBtn addTarget:self action:@selector(deleteeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setTitleColor:kColorDarkGreen forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        // 设置Button边框
        [deleteBtn.layer setBorderWidth:1.0];
        //设置边框颜色有两种方法：第一种如下:
        //        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        //        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 0, 1 });
        [deleteBtn.layer setBorderColor:kColorDarkGreen.CGColor ];//边框颜色
        //第二种方法如下:
        //_testButton.layer.borderColor=[UIColor grayColor].CGColor;
        deleteBtn.layer.cornerRadius = 5;
        [bottomView addSubview:deleteBtn];
        
        UIButton *updateBtn = [[UIButton alloc] init];
        [updateBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        updateBtn.backgroundColor = kColorDarkGreen;
        [updateBtn addTarget:self action:@selector(addOrUpdateSaveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [updateBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        updateBtn.layer.cornerRadius = 5;
        [bottomView addSubview:updateBtn];
        
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bottomView.mas_centerX).multipliedBy(0.52);
            make.centerY.mas_equalTo(bottomView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(kUIScreenWidth/2 -25, 35));
        }];
        
        [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bottomView.mas_centerX).multipliedBy(1.48);
            make.centerY.mas_equalTo(bottomView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(kUIScreenWidth/2 -25, 35));
        }];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
