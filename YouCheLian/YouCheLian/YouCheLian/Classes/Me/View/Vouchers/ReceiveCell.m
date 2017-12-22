//
//  ShopCell.m
//  YouCheLian
//
//  Created by Mike on 15/11/27.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "ReceiveCell.h"
#import "UIImageView+WebCache.h"

@interface ReceiveCell()


@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ReceiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ReceiveCell";
    ReceiveCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格  灰色
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)setModel:(VouchersDataListModel *)model {
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
}


@end
