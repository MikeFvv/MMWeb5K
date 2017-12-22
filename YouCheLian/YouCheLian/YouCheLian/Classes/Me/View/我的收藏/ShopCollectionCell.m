//
//  GoodsCollectionCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/24.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ShopCollectionCell.h"
#import "ShopCollectionModel.h"

@interface ShopCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *merchNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end

@implementation ShopCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ShopCollectionCell";
    ShopCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格  灰色
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

-(void)setModel:(ShopCollectionModel *)model{
    _model = model;
    
    self.merchNameLabel.text = model.name;
    self.workTimeLabel.text = model.worktime;
    self.distance.text = model.address;
    [self.iconView ww_setImageWithString:model.imgUrl wihtImgName:@"image_placeholder"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

