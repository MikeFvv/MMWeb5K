//
//  DetailsPhotoModels.h
//  motoronline
//
//  Created by Mike on 16/1/25.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
///车型相册 焦点广告图
@interface DetailsPhotoModels : NSObject



@property (nonatomic,strong) NSArray *dataList;
// 具体消息描述
@property (nonatomic, copy) NSString *res_desc;
// 9058
@property (nonatomic, copy) NSString *res_code;
// 返回编号
@property (nonatomic, copy) NSString *res_num;

// 总条数
@property (nonatomic, copy) NSString *res_pageTotalSize;


@end


