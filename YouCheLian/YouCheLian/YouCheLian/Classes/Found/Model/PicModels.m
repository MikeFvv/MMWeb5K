//
//  PicModels.m
//  motoronline
//
//  Created by Mike on 16/1/3.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import "PicModels.h"
#import <MJExtension.h>
#import "PicModel.h"

@implementation PicModels

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+(NSDictionary *)objectClassInArray
{
    return @{@"dataList":[PicModel class]};
}

@end
