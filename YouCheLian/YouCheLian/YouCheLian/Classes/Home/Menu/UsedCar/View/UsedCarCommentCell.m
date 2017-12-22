//
//  UsedCarCommentCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UsedCarCommentCell.h"
#import "UsedCarCommentModel.h"

@interface UsedCarCommentCell()

@property (nonatomic, strong) UIImageView *imagView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation UsedCarCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    //  这个 静态字符串不要与类名相同
    static NSString *ID = @"UsedCarCommentCell";
    UsedCarCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UsedCarCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        //        cell.selectedBackgroundView.backgroundColor = RGB(239, 239, 239);
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imagView = [[UIImageView alloc] init];
        [self addSubview:_imagView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = YHFont(14, NO);;
        [self addSubview: _titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = YHFont(13, NO);;
        _contentLabel.numberOfLines = 0; // 换行
        [self addSubview: _contentLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = YHFont(10, NO);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview: _timeLabel];
        
        [_imagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).with.offset(15);
            make.top.mas_equalTo(self.mas_top).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(42, 42));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imagView.mas_right).with.offset(8);
            make.top.mas_equalTo(_imagView.mas_top);
        }];

        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).with.offset(-15);
            make.centerY.mas_equalTo(_titleLabel.mas_centerY);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLabel.mas_bottom).with.offset(10);
            make.left.mas_equalTo(_imagView.mas_right).with.offset(8);
            make.right.mas_equalTo(self.mas_right).with.offset(-15);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineBackColor;
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setModel:(UsedCarCommentModel *)model {
    _model = model;
    
    [_imagView ww_setImageWithString:model.headUrl wihtImgName:@"head_icon"];
    
    if (model.nickName == nil || [model.nickName isEqualToString:@""]) {
        _titleLabel.text = model.userPhone;
    } else {
         _titleLabel.text = model.nickName;
    }
    
    _contentLabel.text = model.content;
    _timeLabel.text = model.addTime;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
