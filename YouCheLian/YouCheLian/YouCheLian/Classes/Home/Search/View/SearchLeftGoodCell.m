//
//  SearchLeftGoodCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/15.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "SearchLeftGoodCell.h"

@interface SearchLeftGoodCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end



@implementation SearchLeftGoodCell

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
