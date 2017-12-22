//
//  ReleaseSelectTableViewCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ReleaseSelectTableViewCell.h"

@interface ReleaseSelectTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@end

@implementation ReleaseSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(ReleaseViewModel *)model{
    [super setModel:model];
    
    self.titleLabel.text = model.title;
    
    
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ReleaseSelectTableViewCell";
    ReleaseSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
