//
//  HomeDiscountCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "HomeDiscountCell.h"
#import "HomeDiscountModel.h"

@interface HomeDiscountCell()

@property (nonatomic, strong) UIImageView *imagView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation HomeDiscountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    //  这个 静态字符串不要与类名相同
    static NSString *ID = @"HomeDiscountCell";
    HomeDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HomeDiscountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
    
}
//withFrame:(CGRect)frame
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imagView = [[UIImageView alloc] init];
        // 图片做等比例放大、超出部分裁剪、居中处理
        _imagView.contentMode = UIViewContentModeScaleAspectFill;
        _imagView.clipsToBounds = YES;  // 超出边框的内容都剪掉
        
        [self addSubview:_imagView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = YHFont(16, NO);;
        _titleLabel.textColor = kGlobalColor;
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = YHFont(15, NO);;
        _contentLabel.textColor = kGlobalFontColor;
        _contentLabel.numberOfLines = 4;
        [self addSubview:_contentLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:0.949  green:0.949  blue:0.949 alpha:1];
        [self addSubview:lineView];
       
        [_imagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).with.offset(kGlobalMargin);
            make.size.mas_equalTo(CGSizeMake(kUIScreenWidth*0.45, 110));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imagView.mas_top).with.offset(6);
            make.left.mas_equalTo(_imagView.mas_right).with.offset(10);
            make.right.mas_equalTo(self.mas_right).with.offset(-15);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_imagView.mas_centerY).multipliedBy(1.3);
//            make.top.mas_equalTo(_titleLabel.mas_bottom).with.offset(10);
            make.left.mas_equalTo(_imagView.mas_right).with.offset(10);
            make.right.mas_equalTo(self.mas_right).with.offset(-15);
//            make.bottom.mas_equalTo(_imagView.mas_bottom);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setModel:(HomeDiscountModel *)model {
    _model = model;
    [_imagView ww_setImageWithString:model.posterUrl wihtImgName:@"image_placeholder"];
    _titleLabel.text = model.preTitle;
    
//    _contentLabel.text = @"电费啊sdfadfasdfasdfasdf水电费安师大收到收到收到水电费水电费水电费水电费水电费水电费水电费收到";
    _contentLabel.text = model.actDesc;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
