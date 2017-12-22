//
//  CarDetailsModel.m
//  motoronline
//
//  Created by Mike on 16/1/25.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import "CarDetailsModel.h"
#import <MJExtension.h>
#import "CarColorListModel.h"
#import "CarServiceListModel.h"


@implementation CarDetailsModel

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
        _cellHeight =  carNameH + sketchH + 50 + 15 + 24;
    }
    return _cellHeight;
}



@end
