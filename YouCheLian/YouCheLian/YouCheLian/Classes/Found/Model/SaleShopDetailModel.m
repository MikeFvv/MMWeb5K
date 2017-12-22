//
//  SaleShopDetailModel.m
//  motoronline
//
//  Created by Mike on 16/2/22.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import "SaleShopDetailModel.h"

@implementation SaleShopDetailModel

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"carId" : @"id"
             };
}

@end