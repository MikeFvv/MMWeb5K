//
//  MeModel.m
//  YouCheLian
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "MeCell.h"
#import "MeModel.h"

@interface MeCell ()

@end

@implementation MeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //iOS 7.x 左分割线左对齐到屏幕边缘
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        //iOS 8.x 左分割线左对齐到屏幕边缘
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}



+(instancetype)cellWithTableView:(UITableView *)tableView meModel:(MeModel*)mineModel{
    
    static NSString *meCell = @"MeCell";
    MeCell *cell = [tableView dequeueReusableCellWithIdentifier:meCell];
    if (cell == nil) {
        cell = [[MeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:meCell];
    }
    NSString *imageStr = [NSString stringWithFormat:@"%@", mineModel.imageName];
    cell.imageView.image = [UIImage imageNamed:imageStr];
    cell.textLabel.text = mineModel.title;
//    cell.detailTextLabel.text = @"哈哈";
    
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.tintColor = kFontColorGray;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
