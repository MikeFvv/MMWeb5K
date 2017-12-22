//
//  HomeDiscountModels.h
//  YouCheLian
//
//  Created by Mike on 16/3/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

// 优惠推荐
@interface HomeDiscountModels : NSObject

// 返回编号
@property (nonatomic, copy) NSString *res_num;
// 9096
@property (nonatomic, copy) NSString *res_code;
// 对应类型枚举表 具体消息描述
@property (nonatomic, copy) NSString *res_desc;
// 总条数
@property (nonatomic, assign) NSInteger res_pageTotalSize;

@property (nonatomic, strong) NSArray *dataList;

@end
