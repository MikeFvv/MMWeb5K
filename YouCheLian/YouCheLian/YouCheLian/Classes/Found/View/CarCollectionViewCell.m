//
//  CarCollectionViewCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/22.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "CarCollectionViewCell.h"
#import "MotoListModel.h"

@interface CarCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation CarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor redColor];
}


- (void)setModel:(MotoListModel *)model {
    _model = model;
    [_imgView ww_setImageWithString:model.ImgUrl wihtImgName:@"image_placeholder"];
    self.titleLabel.text = model.ProName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.Price];
}

@end
