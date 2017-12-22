//
//  ShopNoCell.m
//  YouCheLian
//
//  Created by Mike on 15/11/27.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "VoucherNoCell.h"

@interface VoucherNoCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation VoucherNoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.text = @"无";
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"VoucherNoCell";
    VoucherNoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格  灰色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
