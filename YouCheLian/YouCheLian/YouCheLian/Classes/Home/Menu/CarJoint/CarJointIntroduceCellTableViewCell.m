//
//  CarJointIntroduceCellTableViewCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/4.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "CarJointIntroduceCellTableViewCell.h"
#import "CarDetailsModel.h"

@interface CarJointIntroduceCellTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *sketchLabel;
@property (weak, nonatomic) IBOutlet UILabel *DepositLabel;  // 定金
@property (weak, nonatomic) IBOutlet UILabel *expressTypeLabel;
@end

@implementation CarJointIntroduceCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CarJointIntroduceCellTableViewCell";
    CarJointIntroduceCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setModel:(CarDetailsModel *)model {
    _model = model;
    
    _carNameLabel.text = model.carName;
    _sketchLabel.text = model.sketch;
    if (model.earnestMoney == nil || !(model.earnestMoney.length > 0)) {
        _DepositLabel.text = [NSString stringWithFormat:@"活动价 ¥ 0"];
    }
    _DepositLabel.text = model.earnestMoney;  // 定金
//    _activityPriceLabel.text = [NSString stringWithFormat:@"活动价 ¥ %@", model.price];   // 活动价
//    _storePriceLabel.text = model.marketPrice; // 门店 = 市场价
    _expressTypeLabel.text = [NSString stringWithFormat:@"快递：%@", model.express];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
