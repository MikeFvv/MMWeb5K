//
//  HomeFocusModel.h
//  CheLunShiGuang
//
//  Created by Mike on 15/10/31.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeFocusModel : NSObject

@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, copy) NSString *res_code;

// 对应类型枚举表
@property (nonatomic, copy) NSString *res_desc;
// 返回编号
@property (nonatomic, copy) NSString *res_num;
// 分页
@property (nonatomic, assign) NSInteger res_pageTotalSize;


+(instancetype)appWithDict:(NSDictionary *)dict;


@end
