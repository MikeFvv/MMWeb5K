//
//  FoundDetailsCommentCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/21.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FoundDetailsCommentCell.h"

@interface FoundDetailsCommentCell ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imagView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation FoundDetailsCommentCell

//删除方法
- (IBAction)deteleBtnAction:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定删除?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];

    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        // 取消登录选择
    } else {
        
        if ([self.delegate respondsToSelector:@selector(FoundDetailsCommentCellDidClickDeleteBtn:)]) {
            
            [self.delegate FoundDetailsCommentCellDidClickDeleteBtn:self];
            
        }
        
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

- (void)setModel:(FoundCommentModel *)model {
    _model = model;
    
    [_imagView ww_setImageWithString:model.imgUrl wihtImgName:@"Found_protrait"];
    _titleLabel.text = model.Nick;
    
    if(model.comment.length > 2){
        NSString *str = [model.comment substringWithRange:NSMakeRange(0, 2)];
        NSRange range =  [model.comment rangeOfString:@"："];
        if ([str isEqualToString:@"回复"] && range.length != 0  ) {
            
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:model.comment];
            [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.561  green:0.769  blue:0.122 alpha:1] range:NSMakeRange(2, range.location + range.length - 2)];
            _contentLabel.attributedText = attStr;
        }else{
            _contentLabel.text = model.comment;
        }
    }else{
        _contentLabel.text = model.comment;
    }
    
    _timeLabel.text = model.addTime;
    
    
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FoundDetailsCommentCell";
    FoundDetailsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格  灰色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
