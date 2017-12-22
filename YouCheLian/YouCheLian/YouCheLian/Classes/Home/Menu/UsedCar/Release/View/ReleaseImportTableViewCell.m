//
//  ReleaseImportTableViewCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ReleaseImportTableViewCell.h"

#define kMaxLength 16

@interface ReleaseImportTableViewCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) int maxLength;



@end

@implementation ReleaseImportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentTextFiled.delegate = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object: self.contentTextFiled];
}


-(void)textFiledEditChanged:(NSNotification *)obj{
    
    if (self.indexPath.row == 0) {
        self.maxLength = 25;
    }else if (self.indexPath.row == 5){
        self.maxLength = 10;
    }else if (self.indexPath.row == 6){
        self.maxLength = 11;
    }else {
        self.maxLength = 15;
    }
        
    
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    NSString *lang = [[textField textInputMode] primaryLanguage];
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.maxLength) {
                textField.text = [toBeString substringToIndex:self.maxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        self.contentTextFiled.text = textField.text;
        if (toBeString.length > self.maxLength) {
            textField.text = [toBeString substringToIndex:self.maxLength];
        }
    }
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.contentTextFiled];
}


-(void)setModel:(ReleaseViewModel *)model{
    [super setModel:model];
    
    self.titleLabel.text = model.title;
    self.contentTextFiled.placeholder = model.placeholderTitle;
    if ([model.title isEqualToString:@"价格(人民币¥)"] || [model.title isEqualToString:@"联系电话"]) {
        
        self.contentTextFiled.keyboardType = UIKeyboardTypePhonePad;
        
    }
    
    
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ReleaseImportTableViewCell";
    ReleaseImportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITextFiledDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
   
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //限定只能输入数字
    if(self.indexPath.row == 3 || self.indexPath.row == 6){
        
        BOOL res = YES;
        NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        int i = 0;
        while (i < string.length) {
            NSString * string1 = [string substringWithRange:NSMakeRange(i, 1)];
            NSRange range = [string1 rangeOfCharacterFromSet:tmpSet];
            if (range.length == 0) {
                res = NO;
                break;
            }
            i++;
        }
        return res;
    }
    

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
