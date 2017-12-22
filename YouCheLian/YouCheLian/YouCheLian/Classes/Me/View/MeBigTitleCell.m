//
//  MeBigTitleCell.m
//  YouCheLian
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "MeBigTitleCell.h"

@implementation MeBigTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *meBigTitleCell = @"MeCell";
    MeBigTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:meBigTitleCell];
    if (cell == nil) {
        cell = [[MeBigTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:meBigTitleCell];
    }
   
    cell.textLabel.text = @"我的订单";
//    cell.backgroundColor =[UIColor redColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

@end
