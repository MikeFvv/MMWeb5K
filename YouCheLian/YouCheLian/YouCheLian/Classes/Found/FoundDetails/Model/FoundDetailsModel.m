//
//  FoundDetailsModel.m
//  YouCheLian
//
//  Created by Mike on 16/3/21.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FoundDetailsModel.h"

@implementation FoundDetailsModel

- (CGFloat)cellHeight {
    if (!_cellHeight) {
//        CGFloat contentW = kUIScreenWidth - 100; // 屏幕宽度减去左右间距
//        CGFloat contentH = [self.content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
//                                                      options:NSStringDrawingUsesLineFragmentOrigin
//                                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}
//                                                      context:nil].size.height;
//        _cellHeight = 118 - 32 + contentH;
//        
//        if (self.dataList.count > 0) {
//            _cellHeight += 110;
//        }
        CGFloat imageWidth = (kUIScreenWidth - 88 - 2 * 10) / 3;
        CGFloat imageHetght = imageWidth;
        
        CGFloat contentW = kUIScreenWidth - 88; // 屏幕宽度减去左右间距
        CGFloat contentH = [self.content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}
                                                      context:nil].size.height;
        _cellHeight = 24 + 17 + 10 + 15 + 20 + 2 + contentH ;
        
        if (self.dataList.count > 0) {
            NSInteger count = (self.dataList.count - 1) / 3;
            _cellHeight += (imageHetght + 10 + count *(imageHetght + 10));
        }
        //若评论为空，只有图片
        if (self.content == nil || [self.content isEqualToString:@""]) {
            _cellHeight -= 20;
        }

        
    }
    return _cellHeight;
}
/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+(NSDictionary *)objectClassInArray
{
    return @{@"dataList":[FoundDetailsImageModel class]};
}


@end

@implementation FoundDetailsImageModel

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"
             };
}


@end
