//
//  ShopDetailsModel.m
//  YouCheLian
//
//  Created by Mike on 15/12/11.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "ShopDetailsModel.h"
#import "ServiceListModel.h"
#import "MotoListModel.h"
#import "ActListModel.h"


/// 商家详情
@implementation ShopDetailsModel

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+(NSDictionary *)objectClassInArray
{
    return @{@"servicelist":[ServiceListModel class],
             @"motolist":[MotoListModel class],
             @"actList":[ActListModel class]
             };
}



@end
