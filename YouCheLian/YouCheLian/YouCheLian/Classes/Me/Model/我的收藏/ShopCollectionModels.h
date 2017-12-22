//
//  ShopCollectionModels.h
//  YouCheLian
//
//  Created by Mike on 16/3/24.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCollectionModels : NSObject

@property (nonatomic, strong) NSArray *dataList;

// 对应类型枚举表
@property (nonatomic, copy) NSString *res_desc;
// 9014
@property (nonatomic, copy) NSString *res_code;
// 返回编号
@property (nonatomic, copy) NSString *res_num;
//  总条数
@property (nonatomic, assign) NSInteger res_pageTotalSize;

@end
