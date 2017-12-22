//
//  UsedCarCommentModel.m
//  YouCheLian
//
//  Created by Mike on 16/3/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UsedCarCommentModel.h"

@implementation UsedCarCommentModel


/// 计算 descrip 详细描述 高度
- (CGFloat)cellHeight {
    if (!_cellHeight) {
        CGFloat contentW = kUIScreenWidth - 30; // 屏幕宽度减去左右间距
        CGFloat contentH = [self.content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]}
                                                      context:nil].size.height;
        _cellHeight = 58 + contentH;
        
    }
    return _cellHeight;
}


@end
