//
//  FoundCarDetailsModel.m
//  YouCheLian
//
//  Created by Mike on 16/3/5.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FoundCarDetailsModel.h"
#import <MJExtension.h>
#import "CarColorListModel.h"
#import "CarServiceListModel.h"


@implementation FoundCarDetailsModel

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+(NSDictionary *)objectClassInArray
{
    return @{@"colorList":[CarColorListModel class],
             @"serviceList": [CarServiceListModel class]
             };
}


- (CGFloat)cellHeight {
    if (!_cellHeight) {
        CGFloat contentW = kUIScreenWidth - 20; // 屏幕宽度减去左右间距
        CGFloat carNameH = [self.carName boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]}
                                                      context:nil].size.height;
        CGFloat sketchH = [self.sketch boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f]}
                                                    context:nil].size.height;
        
        if (carNameH == 0) {
            carNameH = 20;
        }
        if (sketchH == 0) {
            sketchH = 20;
        }
        _cellHeight = 20 + carNameH + sketchH + 50;
    }
    return _cellHeight;
}


@end
