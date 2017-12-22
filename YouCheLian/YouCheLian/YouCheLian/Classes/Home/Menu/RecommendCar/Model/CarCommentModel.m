//
//  CarCommentModel.m
//  motoronline
//
//  Created by Mike on 16/1/27.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import "CarCommentModel.h"
static CGFloat const contentFont = 12.f;


@implementation CarCommentModel


- (CGFloat)cellHeight {
    if (!_cellHeight) {
        CGFloat contentW = kUIScreenWidth - 68; // 屏幕宽度减去左右间距
        CGFloat contentH = [self.content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentFont]}
                                                      context:nil].size.height;
        _cellHeight = 60 + contentH;
        
        if (_imageUrls.length > 0) {
            _cellHeight += 90 + 10;
        }

    }
    return _cellHeight;
}


@end
