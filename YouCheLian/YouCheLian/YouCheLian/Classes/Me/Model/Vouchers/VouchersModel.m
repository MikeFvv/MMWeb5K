//
//  CollectionModel.m
//  YouCheLian
//
//  Created by Mike on 15/11/28.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "VouchersModel.h"
#import <MJExtension.h>
#import "VouchersDataListModel.h"


@implementation VouchersModel

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+(NSDictionary *)objectClassInArray
{
    return @{@"dataList":[VouchersDataListModel class]};
}


@end
