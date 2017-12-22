//
//  InformationCell.m
//  YouCheLian
//
//  Created by Mike on 15/11/27.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "OverdueCell.h"
#import "UIImageView+WebCache.h"

@interface OverdueCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation OverdueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OverdueCell";
    OverdueCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格  灰色
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)setModel:(VouchersDataListModel *)model{
    _model = model;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
}

@end
