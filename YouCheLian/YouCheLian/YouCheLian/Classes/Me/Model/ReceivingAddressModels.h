//
//  ReceivingAddressModels.h
//  YouCheLian
//
//  Created by Mike on 16/3/21.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceivingAddressModels : NSObject

// 返回编号
@property (nonatomic, copy) NSString *res_num;
// 9019
@property (nonatomic, copy) NSString *res_code;
// 对应类型枚举表 具体消息描述
@property (nonatomic, copy) NSString *res_desc;
// 总条数
@property (nonatomic, assign) NSInteger res_pageTotalSize;

@property (nonatomic, strong) NSArray *dataList;

@end
