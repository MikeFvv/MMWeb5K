//
//  UsedCarModels.h
//  YouCheLian
//
//  Created by Mike on 15/12/9.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsedCarModels : NSObject

@property (nonatomic, strong) NSArray *dataList;

// 对应类型枚举表
@property (nonatomic, copy) NSString *res_desc;
// 9040
@property (nonatomic, copy) NSString *res_code;
// 返回编号
@property (nonatomic, copy) NSString *res_num;
// 总条数
@property (nonatomic, assign) NSInteger res_pageTotalSize;

@end
