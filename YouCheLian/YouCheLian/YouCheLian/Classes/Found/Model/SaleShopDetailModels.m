//
//  SaleShopDetailModels.m
//  motoronline
//
//  Created by Mike on 16/2/22.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import "SaleShopDetailModels.h"
#import "SaleShopDetailModel.h"

@implementation SaleShopDetailModels

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+(NSDictionary *)objectClassInArray
{
    return @{@"dataList":[SaleShopDetailModel class]};
}

@end
