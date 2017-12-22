//
//  GoodsColorCell.m
//  motoronline
//
//  Created by Mike on 16/1/26.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import "GoodsColorCell.h"

@interface GoodsColorCell ()

@property (weak, nonatomic) IBOutlet UILabel *selectColorLabel;

@end

@implementation GoodsColorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSelectInfo:(NSString *)selectInfo{
    _selectInfo =selectInfo;
    
    self.selectColorLabel.text = selectInfo;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"GoodsColorCell";
    GoodsColorCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格  灰色
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
