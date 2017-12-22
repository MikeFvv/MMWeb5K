//
//  FoundCarIntroduceCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/5.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FoundCarIntroduceCell.h"
#import "FoundCarDetailsModel.h"

@interface FoundCarIntroduceCell ()
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *sketchLabel;
@property (weak, nonatomic) IBOutlet UILabel *DepositLabel;  // 定金
@property (weak, nonatomic) IBOutlet UILabel *expressTypeLabel;

@end

@implementation FoundCarIntroduceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FoundCarIntroduceCell";
    FoundCarIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setModel:(FoundCarDetailsModel *)model {
    _model = model;
    
    _carNameLabel.text = model.carName;
    _sketchLabel.text = model.sketch;
    _DepositLabel.text = [NSString stringWithFormat:@"%@",model.price];  //
    _expressTypeLabel.text = [NSString stringWithFormat:@"%@", model.express];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
