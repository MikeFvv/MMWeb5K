//
//  ReceivingAddressModel.m
//  YouCheLian
//
//  Created by Mike on 15/11/24.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "ReceivingAddressModel.h"

@implementation ReceivingAddressModel

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


/// 计算 descrip 详细描述 高度
- (CGFloat)cellHeight {
    if (!_cellHeight) {
        CGFloat contentW = kUIScreenWidth - 35; // 屏幕宽度减去左右间距
        CGFloat contentH = [self.address boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]}
                                                      context:nil].size.height;
        _cellHeight = 80 + contentH;
        
    }
    return _cellHeight;
}


/**
 *  快速创建一个模型对象
 *
 */
//+(instancetype)appWithDict:(NSDictionary *)dict{
//    // self:哪个类调用该方法，self就指向那个类
//    return [[self alloc] initWithDict:dict];
//}
//
//-(instancetype)initWithDict:(NSDictionary *)dict{
//    if (self = [super init]) {
//        [self setValuesForKeysWithDictionary:dict];
//    }
//    return self;
//}


@end
