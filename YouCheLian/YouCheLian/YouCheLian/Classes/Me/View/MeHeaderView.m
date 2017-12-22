//
//  MeHeaderView.m
//  YouCheLian
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "MeHeaderView.h"
#import "PersonalInfoModel.h"

@interface MeHeaderView()

@property (nonatomic, strong) UIImageView *imagView;
@property (nonatomic, strong) UIButton *loginNameBtn;
@property (nonatomic, strong) UIButton *newsBtn;
// 消息 红色提示
@property (nonatomic, strong) UILabel *newsLabel;

@end

@implementation MeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _bgImagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kMeHeadHeight)];
        _bgImagView.backgroundColor = [UIColor colorWithRed:0.561  green:0.765  blue:0.125 alpha:1];
        _bgImagView.userInteractionEnabled = YES;
        [self addSubview:_bgImagView];
        
        /******* 帐号昵称 ********/
        _loginNameBtn = [[UIButton alloc] init];
        [_loginNameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginNameBtn setTitle:@"注册与登录" forState:UIControlStateNormal];
        _loginNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_loginNameBtn addTarget:self action:@selector(loginOrEditAction) forControlEvents:UIControlEventTouchUpInside];
        _loginNameBtn.titleLabel.font = YHFont(15, NO);;
        [_loginNameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bgImagView addSubview:_loginNameBtn];
        
        /******* 消息 ********/
        _newsBtn = [[UIButton alloc] init];
        [_newsBtn setBackgroundImage:[UIImage imageNamed:@"me_xiaoxi"] forState:UIControlStateNormal];
        [_newsBtn addTarget:self action:@selector(newsBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_bgImagView addSubview:_newsBtn];
        
        
        _newsLabel = [[UILabel alloc] init];
        _newsLabel.layer.cornerRadius = 14/2;
        _newsLabel.textAlignment = NSTextAlignmentCenter;
        _newsLabel.clipsToBounds = YES;  // 超出边框的内容都剪掉
        _newsLabel.textColor = [UIColor whiteColor];
//        _newsLabel.text = @"99";
        _newsLabel.font = YHFont(12, NO);
        _newsLabel.backgroundColor = [UIColor redColor];
        
        [self addSubview:_newsLabel];
        
        [_newsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_newsBtn.mas_right);
            make.centerY.mas_equalTo(_newsBtn.mas_top).with.offset(5);
        }];
        
        
        /******* 头像 ********/
        _imagView = [[UIImageView alloc] init];
        _imagView.image = [UIImage imageNamed:@"me_touxiang"];
        // 切图
        _imagView.layer.cornerRadius = 75/2;
        _imagView.clipsToBounds = YES;  // 就是当取值为YES时，剪裁超出父视图范围的子视图部分
        _imagView.layer.borderColor = [UIColor whiteColor].CGColor;
        _imagView.layer.borderWidth = 3;
        _imagView.userInteractionEnabled = YES;
        //添加图片的点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginOrEditAction)];
        //添加手势到视图
        [_imagView addGestureRecognizer:tap];
        [_bgImagView addSubview:_imagView];
        
        
        [_newsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).with.offset(-20);
            make.top.mas_equalTo(self.mas_top).with.offset(25);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
        
        [_imagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgImagView.mas_centerX);
            make.bottom.mas_equalTo(_loginNameBtn.mas_top).with.offset(-8);
            make.size.mas_equalTo(CGSizeMake(75, 75));
        }];
        
        [_loginNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgImagView.mas_left);
            make.right.mas_equalTo(_bgImagView.mas_right);
            make.bottom.mas_equalTo(_bgImagView.mas_bottom).with.offset(-10);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

- (void)scrollDidScroll:(UIScrollView *)scrollView {
    CGFloat offset_Y = scrollView.contentOffset.y;
    if (offset_Y < 0) {
        
        [_bgImagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(offset_Y);
            make.left.mas_equalTo(self.mas_left).with.offset(offset_Y / 2);
            make.right.mas_equalTo(self.mas_right).with.offset(-offset_Y / 2);
            make.height.mas_equalTo(kMeHeadHeight+(-offset_Y));
        }];
    }
    [self layoutIfNeeded];
}



-(void)setModel:(PersonalInfoModel *)model {
    _model = model;
    
    if ([YHUserInfo shareInstance].isLogin == NO) {
        _imagView.image = [UIImage imageNamed:@"me_touxiang"];
        [_loginNameBtn setTitle:@"注册与登录" forState:UIControlStateNormal];
        
    }else {
        if (![model.uNickname isEqualToString:@""]) { // 有昵称显示昵称
            [_loginNameBtn setTitle: model.uNickname forState:UIControlStateNormal];
        } else {  // 否则显示手机号
            [_loginNameBtn setTitle:[YHUserInfo shareInstance].uPhone forState:UIControlStateNormal];
        }
        [_imagView ww_setImageWithString:model.uHeadUrl wihtImgName:@"me_touxiang"];
    }
 
}

- (void)setSysmsgneedreadNum:(NSNumber *)sysmsgneedreadNum{
    _sysmsgneedreadNum = sysmsgneedreadNum;
    
    _newsLabel.text = sysmsgneedreadNum.stringValue;
    
    if (sysmsgneedreadNum.stringValue.length == 1) {
        [_newsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(14);
        }];
        
        if (sysmsgneedreadNum.integerValue == 0) {
            _newsLabel.text = @"";
        }
        
    } else if (sysmsgneedreadNum.stringValue.length == 2) {
        [_newsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(22);
        }];
    }else if (sysmsgneedreadNum.stringValue.length > 2) {
        [_newsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
        }];
        _newsLabel.text = @"99+";
    }

    
    
    
}



///  消息
- (void)newsBtnAction
{
    if ([self.delegate respondsToSelector:@selector(newsBtnAction)]) {
        [self.delegate newsBtnAction];
    }
}


// 登录
- (void)loginOrEditAction {
    
    if ([self.delegate respondsToSelector:@selector(loginOrEditDelegateAction)]) {
        [self.delegate loginOrEditDelegateAction];
    }
}

@end
