//
//  ShopDiscountCell.m
//  YouCheLian
//
//  Created by Mike on 15/12/16.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "ShopDiscountCell.h"
#import "VoucherModel.h"

@interface ShopDiscountCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ShopDiscountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ShopDiscountCell";
    ShopDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格  灰色
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}


- (void)setModel:(VoucherModel *)model {
    if (model == nil) {
        return;
    }
    _model = model;
    [_imgView ww_setImageWithString:@"" wihtImgName:@"home_menu_Vouchers_no"];
    // ^^^
    _titleLabel.text = model.title;
    _moneyLabel.text = [NSString stringWithFormat:@"￥ %f元", model.money];
    _dateLabel.text = [NSString stringWithFormat:@"有效期至%@",model.time];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
