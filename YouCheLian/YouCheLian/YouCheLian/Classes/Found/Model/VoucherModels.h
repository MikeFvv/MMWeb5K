//
//  VoucherModels.h
//  motoronline
//
//  Created by Mike on 16/1/4.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
// 商家代金券
@interface VoucherModels : NSObject

@property (nonatomic, strong) NSArray *dataList;

// 对应类型枚举表
@property (nonatomic, copy) NSString *res_desc;

@property (nonatomic, copy) NSString *res_code;
// 返回编号
@property (nonatomic, copy) NSString *res_num;
// 总页数
@property (nonatomic, assign) NSInteger res_pageTotalSize;

@end
