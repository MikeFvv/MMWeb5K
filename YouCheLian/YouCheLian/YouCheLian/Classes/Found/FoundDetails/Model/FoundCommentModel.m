//
//  FoundCommentModel.m
//  YouCheLian
//
//  Created by Mike on 16/3/21.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FoundCommentModel.h"

@implementation FoundCommentModel

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        CGFloat contentW = kUIScreenWidth - 88; // 屏幕宽度减去左右间距
        CGFloat contentH = [self.comment boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}
                                                      context:nil].size.height;
        _cellHeight = 118 - 47 + contentH;
        
       
    }
    return _cellHeight;
}


@end
