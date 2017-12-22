//
//  UsedCarCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/5.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UsedCarCell.h"

@interface UsedCarCell()

@property (weak, nonatomic) IBOutlet UIImageView *imagView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImagView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation UsedCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lineView.backgroundColor = kLineBackColor;
    
    // 图片做等比例放大、超出部分裁剪、居中处理
    _imagView.contentMode = UIViewContentModeScaleAspectFill;
    _imagView.clipsToBounds = YES;  // 超出边框的内容都剪掉
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UsedCarCell";
    UsedCarCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}

- (void)setModel:(UsedCarModel *)model {
    _model = model;
    
    NSArray *urlArray = [model.imageUrl componentsSeparatedByString:@","];
    [_imagView ww_setImageWithString:urlArray[0] wihtImgName:@"image_placeholder"];
    
    _titleLabel.text = model.title;
    
    
    if (model.ifTop.integerValue == 1) {   
        _iconImagView.image = [UIImage imageNamed:@"excellent"];
    } else {  // 0 未认证
        _iconImagView.image = [UIImage imageNamed:@""];
    }
    
    if (model.price.floatValue <= 0) {
        _priceLabel.text = @"面议";
    } else {
        _priceLabel.text = [NSString stringWithFormat:@"转让价：%@", model.price];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
