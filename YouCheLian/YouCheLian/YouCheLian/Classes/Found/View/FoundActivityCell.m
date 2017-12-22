//
//  FoundActivityCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FoundActivityCell.h"
#import "ActListModel.h"

@interface FoundActivityCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FoundActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



+(instancetype)cellWithTableView:(UITableView *)tableView {
    //  这个 静态字符串不要与类名相同
    static NSString *ID = @"FoundActivityCell";
    FoundActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[FoundActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = YHFont(14.0, NO);
        _titleLabel.numberOfLines = 3;
        _titleLabel.textColor = kGlobalFontColor;
        [self addSubview:_titleLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineBackColor;
        [self addSubview:lineView];
        
        //创建一个点击手势对象，该对象可以调用handelTap：方法
        //        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTap:)];
        //        [_storeView addGestureRecognizer:tapGes];
        //        [tapGes setNumberOfTouchesRequired:1];  //触摸点个数
        //        [tapGes setNumberOfTapsRequired:1]; //点击次数

        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).with.offset(kGlobalMargin);
            make.right.mas_equalTo(self.mas_right).with.offset(-kGlobalMargin);
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
        
    }
    return self;
}


-(void)setModel:(ActListModel *)model {
    _model = model;
    _titleLabel.text = model.title;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
