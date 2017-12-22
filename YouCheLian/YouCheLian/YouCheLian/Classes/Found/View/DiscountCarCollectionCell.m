//
//  DiscountCarCollectionCell.m
//  YouCheLian
//
//  Created by Mike on 16/4/1.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "DiscountCarCollectionCell.h"
#import "GroupCollectionViewModel.h"
#import "MotoListModel.h"


@interface DiscountCarCollectionCell ()

@property (nonatomic, strong) UIImageView *imagView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation DiscountCarCollectionCell


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    _imagView = [[UIImageView alloc] init];
    // 图片做等比例放大、超出部分裁剪、居中处理
    _imagView.contentMode = UIViewContentModeScaleAspectFill;
    _imagView.clipsToBounds = YES;  // 超出边框的内容都剪掉
    
    _imagView.image = [UIImage imageNamed:@"image_placeholder"];
    //添加边框
//    CALayer *layer = [_imagView layer];
//    layer.borderColor = [[UIColor colorWithRed:0.820  green:0.824  blue:0.824 alpha:1] CGColor];
//    layer.borderWidth = 1.0f;
    
    [self addSubview:_imagView];
    
    CGFloat widthHeight = kUIScreenHeight *0.250;  // 167
    
    [_imagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(widthHeight, widthHeight));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = YHFont(12, NO);
    _titleLabel.textColor = kGlobalFontColor;
    
    [self addSubview:_titleLabel];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imagView.mas_bottom).with.offset(5);
        make.left.mas_equalTo(_imagView.mas_left);
        make.right.mas_equalTo(_imagView.mas_right);
    }];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    _priceLabel.font = YHFont(12, NO);
    _priceLabel.textColor = [UIColor redColor];
    
    [self addSubview:_priceLabel];
    
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-10);
        make.left.mas_equalTo(_imagView.mas_left);
        make.right.mas_equalTo(_imagView.mas_right);
    }];
    
}



- (void)setModel:(MotoListModel *)model {
    _model = model;
    [_imagView ww_setImageWithString:model.ImgUrl wihtImgName:@"image_placeholder"];
    _titleLabel.text = model.ProName;
    _priceLabel.text = [NSString stringWithFormat:@"指导价：¥%@",model.Price];
}



@end
