//
//  PersonalInfoController.m
//  YouCheLian
//
//  Created by Mike on 15/12/4.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "PersonalInfoController.h"
#import "PersonalInfoEditController.h"
#import "PersonalInfoModel.h"
#import <MJFoundation.h>
#import "NSString+Size.h"

@interface PersonalInfoController ()

@property (strong, nonatomic) UIImageView *imagView;


@property (strong, nonatomic) UILabel *nicknameLabel;

@property (strong, nonatomic) UILabel *sexLabel;
///  个性签名
@property (strong, nonatomic) UILabel *autographLabel;


@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) PersonalInfoModel *personalInfoModel;

@end

@implementation PersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initView];
    //    [self getData];
}



- (void)viewWillAppear:(BOOL)animated {
    [self getData];
}


-(void)initNav {
    // 编辑
    UIButton *editBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    editBtn.frame = CGRectMake(0, 0, 50, 20);
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    editBtn.titleLabel.font = YHFont(16, NO);;
    [editBtn setTitleColor:kFontColor forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(OnEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
}

- (void)initView {
    
    
    self.title = @"个人资料";
    
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView];

    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(292);
    }];
    
    _imagView = [[UIImageView alloc] init];
    _imagView.image = [UIImage imageNamed:@"me_Individual_img"];
    _imagView.layer.cornerRadius = 100/2;
    _imagView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imagView.layer.borderWidth = 1;
    _imagView.clipsToBounds = YES;  // 超出边框的内容都剪掉
    [_backView addSubview:_imagView];
    
    
    [_imagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).with.offset(20);
        make.centerX.mas_equalTo(_backView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    /****** 昵 称 ******/
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor colorWithRed:0.824  green:0.827  blue:0.827 alpha:1];
    [_backView addSubview:lineView1];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imagView.mas_bottom).with.offset(20);
        make.left.mas_equalTo(_backView.mas_left);
        make.right.mas_equalTo(_backView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    
    UILabel *nicknameTitle = [[UILabel alloc] init];
    nicknameTitle.text = @"昵 称：";
    nicknameTitle.font = YHFont(15, NO);
    nicknameTitle.textColor = [UIColor colorWithRed:0.086  green:0.094  blue:0.110 alpha:1];
    [_backView addSubview:nicknameTitle];
    
    [nicknameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView1.mas_bottom).with.offset(15);
        make.left.mas_equalTo(_backView.mas_left).with.offset(15);
        make.width.mas_equalTo(50);
    }];
    
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.numberOfLines = 1;
    _nicknameLabel.font = YHFont(15, NO);
    _nicknameLabel.textColor = [UIColor colorWithRed:0.086  green:0.094  blue:0.110 alpha:1];
    [_backView addSubview:_nicknameLabel];
    
    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nicknameTitle.mas_centerY);
        make.left.mas_equalTo(nicknameTitle.mas_right).with.offset(5);
        make.right.mas_equalTo(_backView.mas_right).with.offset(-15);
    }];
    
    /****** 性 别 ******/
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = [UIColor colorWithRed:0.824  green:0.827  blue:0.827 alpha:1];
    [_backView addSubview:lineView2];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView1.mas_bottom).with.offset(50);
        make.left.mas_equalTo(_backView.mas_left);
        make.right.mas_equalTo(_backView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    
    UILabel *sexTitle = [[UILabel alloc] init];
    sexTitle.text = @"性 别：";
    sexTitle.font = YHFont(15, NO);
    sexTitle.textColor = [UIColor colorWithRed:0.086  green:0.094  blue:0.110 alpha:1];
    [_backView addSubview:sexTitle];
    
    [sexTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView2.mas_bottom).with.offset(15);
        make.left.mas_equalTo(_backView.mas_left).with.offset(15);
        make.width.mas_equalTo(50);
    }];
    
    _sexLabel = [[UILabel alloc] init];
    _sexLabel.font = YHFont(15, NO);
    _sexLabel.textColor = [UIColor colorWithRed:0.086  green:0.094  blue:0.110 alpha:1];
    [_backView addSubview:_sexLabel];
    
    [_sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(sexTitle.mas_centerY);
        make.left.mas_equalTo(sexTitle.mas_right).with.offset(5);
        make.right.mas_equalTo(_backView.mas_right).with.offset(-15);
    }];
    
    /****** 个性签名 ******/
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = [UIColor colorWithRed:0.824  green:0.827  blue:0.827 alpha:1];
    [_backView addSubview:lineView3];
    
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView2.mas_bottom).with.offset(50);
        make.left.mas_equalTo(_backView.mas_left);
        make.right.mas_equalTo(_backView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    
    UILabel *autographTitle = [[UILabel alloc] init];
    autographTitle.text = @"个性签名：";
    autographTitle.font = YHFont(15, NO);
    autographTitle.textColor = [UIColor colorWithRed:0.086  green:0.094  blue:0.110 alpha:1];
    [_backView addSubview:autographTitle];
    
    [autographTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView3.mas_bottom).with.offset(15);
        make.left.mas_equalTo(_backView.mas_left).with.offset(15);
        make.width.mas_equalTo(80);
    }];
    
    _autographLabel = [[UILabel alloc] init];
    _autographLabel.font = YHFont(15, NO);
    _autographLabel.numberOfLines = 0;
    _autographLabel.textColor = [UIColor colorWithRed:0.086  green:0.094  blue:0.110 alpha:1];
    [_backView addSubview:_autographLabel];
    
    [_autographLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(autographTitle.mas_top);
        make.left.mas_equalTo(autographTitle.mas_right).with.offset(5);
        make.right.mas_equalTo(_backView.mas_right).with.offset(-15);
    }];
}

#pragma mark - 编辑 跳转
// 编辑
-(void)OnEditBtn:(UIButton *)sender {
    
    UIStoryboard *strory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalInfoEditController *vc = [strory instantiateViewControllerWithIdentifier:@"PersonalInfoEditController"];
    vc.personalInfoModel = self.personalInfoModel;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 请求数据
/// 获取个人资料
- (void)getData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1022" forKey:@"rec_code"];
    [dictParam setValue: [YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        if (error) {
            
        } else {
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                YHLog(@"%@", result);
                self.personalInfoModel = [PersonalInfoModel mj_objectWithKeyValues:result];
                
            }else {
                [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            }
        }
        return YES;
    }];
}


// 赋值
-(void)setPersonalInfoModel:(PersonalInfoModel *)personalInfoModel {
    _personalInfoModel = personalInfoModel;
    
    [_imagView ww_setImageWithString:personalInfoModel.uHeadUrl wihtImgName:@"me_Individual_img"];
    _nicknameLabel.text = personalInfoModel.uNickname;
    if (personalInfoModel.uSex.intValue == 1) {
        _sexLabel.text = @"男";
    } else if (personalInfoModel.uSex.intValue == 2) {
        _sexLabel.text = @"女";
    }
    
    _autographLabel.text = personalInfoModel.uSignature;
    
   CGSize size = [personalInfoModel.uSignature sizeWithContentFont:[UIFont systemFontOfSize:15] limitWidth: (kUIScreenWidth - ( 15*2 +80+5))];
    YHLog(@"-------%f",size.height);
    [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(292+size.height -18);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


