//
//  FiltrateCell.m
//  3198CommercialChance
//
//  Created by iOS开发 on 15/12/8.
//  Copyright © 2015年 路鹏. All rights reserved.
//

#import "FiltrateCell.h"

@implementation FiltrateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.angleImgView.hidden = YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FiltrateCell";
    FiltrateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)setModel:(MyModel *)model{
    _model = model;
    
    self.titleLab.text = model.name;
}
- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        self.titleLab.textColor = [UIColor colorWithRed:0.145  green:0.706  blue:0.345 alpha:1];
        self.angleImgView.hidden = NO;
    }else
    {
        self.titleLab.textColor = [UIColor blackColor];
        self.angleImgView.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
