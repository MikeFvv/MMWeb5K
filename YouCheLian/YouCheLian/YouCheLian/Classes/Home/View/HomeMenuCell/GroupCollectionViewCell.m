//
//  GroupCollectionViewCell.m
//  CheLunShiGuang
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "GroupCollectionViewCell.h"
#import "GroupCollectionViewModel.h"

@interface GroupCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;

//@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

///// 图片数组
//@property(nonatomic,strong) NSArray *images;

@end

@implementation GroupCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    _iconImageView = [[UIImageView alloc] init];
     _nameLabel = [[UILabel alloc] init];
    
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
//    self.backgroundColor = [UIColor redColor];
    self.selectedBackgroundView.backgroundColor = [UIColor redColor];
    _nameLabel.font = YHFont(15, NO);;
    _nameLabel.textColor = kGlobalFontColor;
    
    [self addSubview:_iconImageView];
    [self addSubview:_nameLabel];
    
    CGFloat widthHeight;
    if (IS_IPHONE4) {
        widthHeight = 40.0;
    } else if (IS_IPHONE5) {
        widthHeight = 40.0;
    }else if (IS_IPHONE6) {
        widthHeight = 45.0;
    }else if (IS_IPHONE6_PLUS) {
        widthHeight = 50.0;
    }else {
        widthHeight = 40.0;
    }
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(widthHeight, widthHeight));
//        make.bottom.mas_equalTo(self.nameLabel.mas_top).with.offset(10);
    }];
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).with.offset(6);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
//        make.bottom.mas_equalTo(self.mas_bottom).with.offset(10);
    }];
   
}


- (void)setCollModel:(GroupCollectionViewModel *)collModel {
    _collModel = collModel;
    self.iconImageView.image = [UIImage imageNamed:collModel.icon];
    self.nameLabel.text = collModel.name;
    //暂时屏蔽，功能未开放
    if (collModel.enble == NO) {
        self.userInteractionEnabled = NO;
        self.alpha = 0.3;
    }
}






@end
