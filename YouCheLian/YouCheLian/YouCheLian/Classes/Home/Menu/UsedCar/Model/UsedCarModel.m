//
//  UsedCarModel.m
//  YouCheLian
//
//  Created by Mike on 16/3/5.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UsedCarModel.h"
#import <MJExtension.h>


@implementation UsedCarModel

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"descrip" : @"description"
             };
}

/// 计算 title 高度
- (CGFloat)cellTitleHeight {
    if (!_cellTitleHeight) {
        CGFloat contentW = kUIScreenWidth - 30; // 屏幕宽度减去左右间距
        CGFloat contentH = [self.title boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0f]}
                                                      context:nil].size.height;
        _cellTitleHeight = 90 + 35 + 12 + contentH;
  
    }
    return _cellTitleHeight;
}

/// 计算 descrip 详细描述 高度
- (CGFloat)cellDescripHeight {
    if (!_cellDescripHeight) {
        CGFloat contentW = kUIScreenWidth - 30; // 屏幕宽度减去左右间距
        CGFloat contentH = [self.descrip boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]}
                                                    context:nil].size.height;
        _cellDescripHeight = 70 + 30 + 10 + contentH;
        
    }
    return _cellDescripHeight;
}

@end
