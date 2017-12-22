//
//  CityOneModel.m
//  YouCheLian
//
//  Created by Mike on 16/3/8.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "CityOneModel.h"
#import <MJExtension.h>
#import "CityTwoModel.h"

@implementation CityOneModel

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"pId" : @"id"
             };
}

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+(NSDictionary *)objectClassInArray
{
    return @{@"citylist":[CityTwoModel class]};
}

@end
