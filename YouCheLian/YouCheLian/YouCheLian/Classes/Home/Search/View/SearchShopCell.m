//
//  SearchShopCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/15.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "SearchShopCell.h"

@interface SearchShopCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *merchNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end

@implementation SearchShopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(SearchModel *)model{
    _model = model;
    
    self.merchNameLabel.text = model.merchName;
    self.workTimeLabel.text = model.worktime;
    self.distance.text = [NSString stringWithFormat:@"%@",model.distance];
    [self.iconView ww_setImageWithString:model.imgUrl wihtImgName:@"image_placeholder"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
