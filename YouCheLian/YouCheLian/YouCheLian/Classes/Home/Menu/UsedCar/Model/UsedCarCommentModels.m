//
//  UsedCarCommentModels.m
//  YouCheLian
//
//  Created by Mike on 16/3/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UsedCarCommentModels.h"
#import <MJExtension.h>
#import "UsedCarCommentModel.h"

@implementation UsedCarCommentModels

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+(NSDictionary *)objectClassInArray
{
    return @{@"dataList":[UsedCarCommentModel class]};
}

@end
