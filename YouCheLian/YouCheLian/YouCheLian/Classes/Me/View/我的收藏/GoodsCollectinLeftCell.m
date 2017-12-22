//
//  GoodsCollectinLeftCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "GoodsCollectinLeftCell.h"
#import "ShopCollectionModel.h"

@interface GoodsCollectinLeftCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation GoodsCollectinLeftCell

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
