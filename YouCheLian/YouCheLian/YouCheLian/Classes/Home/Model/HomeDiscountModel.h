//
//  HomeDiscountModel.h
//  YouCheLian
//
//  Created by Mike on 16/3/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeDiscountModel : NSObject
// id
@property (nonatomic, strong) NSNumber *preId;
// 活动标题
@property (nonatomic, copy) NSString *preTitle;
// 海报地址url
@property (nonatomic, copy) NSString *posterUrl;
// 活动描述
@property (nonatomic, copy) NSString *actDesc;
// 活动开始时间
@property (nonatomic, copy) NSString *startTime;
// 活动结束时间
@property (nonatomic, copy) NSString *endTime;
// 剩余天数
@property (nonatomic, strong) NSNumber *reDay;

// 跳转的到 详情 url
@property (nonatomic, copy) NSString *detailUrl;

@end
