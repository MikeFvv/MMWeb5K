//
//  MeSecondCarCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/28.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "MeSecondCarCell.h"

@interface MeSecondCarCell ()

//主要图片
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
//置顶图片
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//发表时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MeSecondCarCell
//编辑按钮点击
- (IBAction)editAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(meSecondCarCellDidEditBtnClick:)]) {
        [self.delegate meSecondCarCellDidEditBtnClick:self];
    }
    
}
//删除按钮点击
- (IBAction)deleteAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(meSecondCarCellDidDeleteBtnClick:)]) {
        [self.delegate meSecondCarCellDidDeleteBtnClick:self];
    }
    
}
//置顶按钮点击
- (IBAction)topAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(meSecondCarCellDidTopBtnClick:)]) {
        [self.delegate meSecondCarCellDidTopBtnClick:self];
    }
    
}

-(void)setModel:(UsedCarModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.timeLabel.text = model.addTime;
    self.priceLabel.text = [NSString stringWithFormat:@"转让价：%@",model.price];
    if (model.ifTop.integerValue == 0) {
        self.topImageView.hidden = YES;
        
    }else if (model.ifTop.integerValue == 1) {
        self.topImageView.hidden = NO;
        
    }
    
     NSArray *urlArray = [model.imageUrl componentsSeparatedByString:@","];
    if (urlArray.count != 0) {
        [self.iconView ww_setImageWithString:urlArray[0] wihtImgName:@"image_placeholder"];
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
