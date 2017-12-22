//
//  CarMoreCollectionViewCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/22.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "CarMoreCollectionViewCell.h"
#import "MotoListModel.h"

#define kMarginWidth 15

@interface CarMoreCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *priceLabel;

@end

@implementation CarMoreCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    self.backgroundColor = [UIColor whiteColor];
    
    _imageView = [[UIImageView alloc] init];
    // 图片做等比例放大、超出部分裁剪、居中处理
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;  // 超出边框的内容都剪掉
    
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    //添加边框
    CALayer * layer = [_imageView layer];
    layer.borderColor = [[UIColor colorWithRed:0.820  green:0.824  blue:0.824 alpha:1] CGColor];
    layer.borderWidth = 1.0f;

    [self.contentView addSubview:self.imageView];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = YHFont(14, NO);;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.font = YHFont(14, NO);;
    _priceLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:_priceLabel];
    
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(kMarginWidth);
        make.left.mas_equalTo(self.mas_left).with.offset(kMarginWidth);
        make.right.mas_equalTo(self.mas_right).with.offset(-kMarginWidth);
        make.height.mas_equalTo(155);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).with.offset(8);
        make.left.mas_equalTo(self.mas_left).with.offset(kMarginWidth);
        make.right.mas_equalTo(self.mas_right).with.offset(-kMarginWidth);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-10);
        make.left.mas_equalTo(self.mas_left).with.offset(kMarginWidth);
        make.right.mas_equalTo(self.mas_right).with.offset(-kMarginWidth);
    }];

    return self;
}

-(void)prepareForReuse
{
    [self setModel:nil];
}

- (void)setModel:(MotoListModel *)model {
    _model = model;
    [self.imageView ww_setImageWithString:model.ImgUrl wihtImgName:@"image_placeholder"];
    self.titleLabel.text = model.ProName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.Price];
}

@end
