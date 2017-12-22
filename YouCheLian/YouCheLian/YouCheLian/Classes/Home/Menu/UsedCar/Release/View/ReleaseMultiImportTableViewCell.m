//
//  ReleaseMultiImportTableViewCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/14.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ReleaseMultiImportTableViewCell.h"

@interface ReleaseMultiImportTableViewCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderTitleLabel;

@end


@implementation ReleaseMultiImportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textView.backgroundColor = [UIColor colorWithRed:0.969  green:0.973  blue:0.976 alpha:1];
    
    _textView.layer.cornerRadius = 5;
    
//    _textView.scrollEnabled = NO;
}

-(void)setModel:(ReleaseViewModel *)model{
    [super setModel:model];
    
    self.titleLabel.text = model.title;
    self.placeholderTitleLabel.text = model.placeholderTitle;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ReleaseMultiImportTableViewCell";
    ReleaseMultiImportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


//把回车键当做退出键盘的响应键  textView退出键盘的操作
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}



#pragma mark - 
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    
//    CGSize size = [self contentSizeOfTextView:textView];
//    YHLog(@"%lf-----%lf",size.width,size.height);
//    self.model.cellHeight = size.height;
//    
////    if ([self.delegate respondsToSelector:@selector(releaseMultiImportTableViewTextView:CellChangeTextFieldText:)]) {
////        
////        [self.delegate releaseMultiImportTableViewTextView:textView CellChangeTextFieldText:text];
////        
////    }
//    
//    return YES;
//}


- (void)textViewDidChange:(UITextView *)textView {
    
    
    
    if ([self.delegate respondsToSelector:@selector(releaseMultiImportTableViewTextView:CellChangeTextFieldText:)]) {
        
        [self.delegate releaseMultiImportTableViewTextView:textView CellChangeTextFieldText:@"22"];
        
    }
    
    if (textView.text.length > 0) {
        self.placeholderTitleLabel.text = @"";
    } else {
        self.placeholderTitleLabel.text = @"请描述商品";
    }
    
}




//计算textView的高度
- (CGSize)contentSizeOfTextView:(UITextView *)textView
{
    CGSize textViewSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];

    return textViewSize;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
