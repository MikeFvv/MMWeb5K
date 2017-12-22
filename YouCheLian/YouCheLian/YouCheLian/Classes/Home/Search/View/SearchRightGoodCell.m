//
//  SearchRightGoodCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/15.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "SearchRightGoodCell.h"

@interface SearchRightGoodCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation SearchRightGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(SearchGoodModel *)model{
    _model = model;
    
    [self.iconView ww_setImageWithString:model.ImgUrl];
    self.titleLabel.text = model.ProName;
    self.priceLabel.text = model.Price;
    
}

@end
