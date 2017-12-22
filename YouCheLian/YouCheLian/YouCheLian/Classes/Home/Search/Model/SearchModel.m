//
//  SearchModel.m
//  YouCheLian
//
//  Created by Mike on 16/3/2.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

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
