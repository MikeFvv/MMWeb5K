//
//  CommentHeaderCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "CommentHeaderCell.h"

@implementation CommentHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)cellWithTableView:(UITableView *)tableView {
    //  这个 静态字符串不要与类名相同
    static NSString *ID = @"CommentHeaderCell";
    CommentHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CommentHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        //        cell.selectedBackgroundView.backgroundColor = RGB(239, 239, 239);
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *viewRect = [[UIView alloc] init];
        viewRect.backgroundColor = [UIColor colorWithRed:0.357  green:0.698  blue:0.788 alpha:1];
        [self addSubview:viewRect];

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = YHFont(16, NO);;
        titleLabel.text = @"留言";
        [self addSubview:titleLabel];
    
        
        [viewRect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).with.offset(15);
            make.top.mas_equalTo(self.mas_top).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(6, 25));
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(viewRect.mas_right).with.offset(8);
            make.centerY.mas_equalTo(viewRect.mas_centerY);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineBackColor;
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
