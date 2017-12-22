//
//  UsedCarCommentModels.h
//  YouCheLian
//
//  Created by Mike on 16/3/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsedCarCommentModels : NSObject

///  返回编号
@property (nonatomic, strong) NSNumber *res_num;
///  9044
@property (nonatomic, copy) NSString *res_code;
///  具体消息描述
@property (nonatomic, copy) NSString *res_desc;
// 总页数
@property (nonatomic, assign) NSInteger res_pageTotalSize;

@property (nonatomic, strong) NSArray *dataList;

@end
