//
//  SearchAllTableViewCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/2.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "SearchHistoryTableViewCell.h"

@interface SearchHistoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SearchHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContent:(NSString *)content{
    _content = content;
    
    self.titleLabel.text = content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
