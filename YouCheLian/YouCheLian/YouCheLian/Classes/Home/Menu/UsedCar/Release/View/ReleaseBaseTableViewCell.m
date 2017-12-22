//
//  ReleaseBaseTableViewCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/8.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ReleaseBaseTableViewCell.h"

@implementation ReleaseBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(ReleaseViewModel *)model{
    _model = model;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
