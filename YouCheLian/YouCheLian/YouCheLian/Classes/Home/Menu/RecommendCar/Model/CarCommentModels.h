//
//  CarCommentModels.h
//  motoronline
//
//  Created by Mike on 16/1/27.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 评价
@interface CarCommentModels : NSObject

@property (nonatomic,strong) NSArray *dataList;
// 具体消息描述
@property (nonatomic, copy) NSString *res_desc;
// 9061
@property (nonatomic, copy) NSString *res_code;
// 返回编号
@property (nonatomic, copy) NSString *res_num;
// 总条数
@property (nonatomic, strong) NSNumber *res_pageTotalSize;
///  全部评价条数 rec_type=0时，返回数据
@property (nonatomic, strong) NSNumber *allCount;
///  好评条数 rec_type=1时，返回数据
@property (nonatomic, strong) NSNumber *goodCount;
///  中评条数rec_type=2时，返回数据
@property (nonatomic, strong) NSNumber *middleCount;
///  差评条数rec_type=3时，返回数据
@property (nonatomic, strong) NSNumber *badCount;
///  有图条数rec_type=4时，返回数据
@property (nonatomic, strong) NSNumber *imgCount;

@end
