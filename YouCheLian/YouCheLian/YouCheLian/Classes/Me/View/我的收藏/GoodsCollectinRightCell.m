//
//  GoodsCollectinRightCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "GoodsCollectinRightCell.h"
#import "ShopCollectionModel.h"

@interface GoodsCollectinRightCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation GoodsCollectinRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setModel:(ShopCollectionModel *)model{
    _model = model;
    
    [self.iconView ww_setImageWithString:model.imgUrl];
    self.titleLabel.text = model.name;
    self.priceLabel.text = model.pPrice;
    
}


@end
