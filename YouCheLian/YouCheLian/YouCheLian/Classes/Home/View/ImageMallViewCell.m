//
//  ImageMallViewCell.m
//  YouCheLian
//
//  Created by Mike on 15/12/14.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "ImageMallViewCell.h"

@interface ImageMallViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation ImageMallViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setModel:(DataListModel *)model{
    _model = model;
    [self.iconView ww_setImageWithString:model.imagUrl];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ImageMallViewCell";
    ImageMallViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格  灰色
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
