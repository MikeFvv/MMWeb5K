//
//  MeSystemMessageModels.h
//  YouCheLian
//
//  Created by Mike on 16/3/23.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeSystemMessageModels : NSObject

// 具体消息描述
@property (nonatomic, copy) NSString *res_desc;
// 9069
@property (nonatomic, copy) NSString *res_code;
// 返回编号
@property (nonatomic, copy) NSString *res_num;

@property (nonatomic, strong) NSArray *DataList;


@end
