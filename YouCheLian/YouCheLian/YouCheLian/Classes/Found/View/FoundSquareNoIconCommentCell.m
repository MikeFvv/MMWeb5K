//
//  FoundSquareNoIconCommentCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/19.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FoundSquareNoIconCommentCell.h"
#import "FoundSquareModel.h"
#import "FoundDetailsModel.h"

@interface FoundSquareNoIconCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imagView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;




@end

@implementation FoundSquareNoIconCommentCell

- (IBAction)commentNumBtn:(id)sender {
    
    
}

- (IBAction)deleteBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(FoundSquareCommentCellDidClickDeleteBtn:withModel:)]) {
        [self.delegate FoundSquareCommentCellDidClickDeleteBtn:sender withModel:self.model];
    }
    
}

- (IBAction)UpvoteNumAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(FoundSquareCommentCellDidClickUpvoteNumBtn:withModel:)]) {
        [self.delegate FoundSquareCommentCellDidClickUpvoteNumBtn:sender withModel:self.model];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //设置头像圆形
    self.imagView.layer.cornerRadius = 24;
    self.imagView.layer.borderWidth = 1;
    self.imagView.layer.borderColor = [UIColor colorWithRed:0.561  green:0.765  blue:0.129 alpha:1].CGColor;
    self.imagView.clipsToBounds = YES;
}

- (void)setModel:(FoundSquareModel *)model {
    _model = model;
   
    
    [_imagView ww_setImageWithString:model.userImg wihtImgName:@"Found_protrait"];
    
    _titleLabel.text = model.userNickname;
    _contentLabel.text = model.content;
    _timeLabel.text = model.publishTime;
    [_commentNumBtn setTitle:[NSString stringWithFormat:@"%d",model.commentNum] forState:UIControlStateNormal];
    [_upvoteNumBtn setTitle:[NSString stringWithFormat:@"%d",model.upvoteNum] forState:UIControlStateNormal];
    
}

- (void)setDataModel:(FoundDetailsModel *)dataModel{
    _dataModel = dataModel;
    // 分割 截取字符串  如果没有图片=0
    //    self.imagArray = [model.imageUrls componentsSeparatedByString:@","];
    
    [_imagView ww_setImageWithString:dataModel.userImg wihtImgName:@"Found_protrait"];
    _titleLabel.text = dataModel.userNickname;
    _contentLabel.text = dataModel.content;
    _timeLabel.text = dataModel.publishTime;
    [_commentNumBtn setTitle:[NSString stringWithFormat:@"%d",dataModel.commentNum] forState:UIControlStateNormal];
    [_upvoteNumBtn setTitle:dataModel.upvoteNum forState:UIControlStateNormal];
    
    
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FoundSquareNoIconCommentCell";
    FoundSquareNoIconCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格  灰色
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
