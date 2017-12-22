//
//  CarShopInfoCell.m
//  motoronline
//
//  Created by Mike on 16/1/26.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import "CarShopInfoCell.h"
#import "CarShopDetailsModel.h"

@interface CarShopInfoCell()
@property (weak, nonatomic) IBOutlet UIImageView *imagView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;
//@property (weak, nonatomic) IBOutlet UILabel *goodsNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumLabel;

@property (weak, nonatomic) IBOutlet UIView *carView;
//@property (weak, nonatomic) IBOutlet UIView *goodsView;


@end

@implementation CarShopInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCarGoodsAction:)];
    _carView.tag = 1;
    [_carView addGestureRecognizer:tap1];
    
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCarGoodsAction:)];
//    _goodsView.tag = 2;
//    [_goodsView addGestureRecognizer:tap2];

    
//    [_contactBtn setHidden:YES];  // 这个控件不显示
    _contactBtn.layer.cornerRadius = 11;
    _contactBtn.layer.borderWidth = 1;
    _contactBtn.layer.borderColor = [UIColor colorWithRed:0.561  green:0.769  blue:0.122 alpha:1].CGColor;
    _contactBtn.clipsToBounds = YES;
    
    UITapGestureRecognizer *tapShop1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShopAction:)];
    [_imagView addGestureRecognizer:tapShop1];
    
    UITapGestureRecognizer *tapShop2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShopAction:)];
    [_titleLabel addGestureRecognizer:tapShop2];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CarShopInfoCell";
    CarShopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



- (void)setModel:(CarShopDetailsModel *)model {
    _model = model;
    
    [_imagView ww_setImageWithString:model.imageUrl wihtImgName:@"image_placeholder"];
    
    _titleLabel.text = model.merName;
    _addressLabel.text = model.address;
    
    [_distanceBtn setTitle:model.distance forState:UIControlStateNormal];  //   离我多少千米
    _carNumLabel.text = model.saleNewCarNum.stringValue;
//    _goodsNumLabel.text = model.saleGoodsNum.stringValue;
    _peopleNumLabel.text = model.followNum.stringValue;
}
- (IBAction)contactBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickcontactBtnAction:)]) {
        [self.delegate clickcontactBtnAction:sender];
    }
}

-(void)clickCarGoodsAction:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(clickCarGoodsAction:)]) {
        [self.delegate clickCarGoodsAction:tap];
    }
}

-(void)clickShopAction:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(clickShopAction:)]) {
        [self.delegate clickShopAction:tap];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
