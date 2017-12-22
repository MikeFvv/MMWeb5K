//
//  HomeTitleCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "HomeTitleCell.h"

@implementation HomeTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    //  这个 静态字符串不要与类名相同
    static NSString *ID = @"HomeTitleCell";
    HomeTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HomeTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
//withFrame:(CGRect)frame
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.clipsToBounds = YES;  // 超出边框的内容都剪掉
        
        iconView.userInteractionEnabled = YES;
        iconView.image = [UIImage imageNamed:@"rectangal"];
        
        [self addSubview:iconView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"优惠推荐";
        titleLabel.font = YHFont(17, NO);;
        titleLabel.textColor = kGlobalFontColor;
        [self addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:0.941  green:0.949  blue:0.949 alpha:1];
        [self addSubview:lineView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).with.offset(kGlobalMargin);
            make.size.mas_equalTo(CGSizeMake(6, 22));
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(iconView.mas_left).with.offset(15);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(1);
        }];
        

        UIImageView *iconImage = [[UIImageView alloc] init];
        iconImage.image = [UIImage imageNamed:@"common_forward"];
        [self addSubview:iconImage];

        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(self.mas_right).with.offset(-15);
            make.size.mas_equalTo(CGSizeMake(9, 15));
        }];
        
        UILabel *moreLabel = [[UILabel alloc] init];
        moreLabel.text = @"更多";
        moreLabel.textColor = kGlobalFontColor;
        moreLabel.font = YHFont(14, NO);
        [self addSubview:moreLabel];
        
        [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(iconImage.mas_left).with.offset(-5);
        }];
        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
