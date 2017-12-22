//
//  CarDetailsSubViewDataModel.h
//  motoronline
//
//  Created by Mike on 16/1/30.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarDetailsSubViewDataModel : NSObject

// 具体消息描述
@property (nonatomic, copy) NSString *res_desc;
// 9059
@property (nonatomic, copy) NSString *res_code;
// 返回编号
@property (nonatomic, copy) NSString *res_num;
// 规格参数(可能存在html标签)
@property (nonatomic, copy) NSString *specifications;
// 图文详情(可能存在html标签)
@property (nonatomic, copy) NSString *content;

@end
