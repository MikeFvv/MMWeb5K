//
//  OrderInfoModel.h
//  YouCheLian
//
//  Created by Mike on 16/3/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfoModel : NSObject

// 对应类型枚举表
@property (nonatomic, copy) NSString *res_desc;
// 9034
@property (nonatomic, copy) NSString *res_code;
// 返回编号
@property (nonatomic, strong) NSNumber *res_num;
// 待付款个数
@property (nonatomic, strong) NSNumber *paymentNum;
// 待付款Url
@property (nonatomic, copy) NSString *paymentUrl;
// 待确认个数
@property (nonatomic, strong) NSNumber *confirmNum;
// 待确认Url
@property (nonatomic, copy) NSString *confirmUrl;
// 待评价个数
@property (nonatomic, strong) NSNumber *evaluationNum;
// 待评价url
@property (nonatomic, copy) NSString *evaluationUrl;
// 全部订单页面（url）
@property (nonatomic, copy) NSString *url;
// 未查看系统消息条数
@property (nonatomic, strong) NSNumber *sysmsgneedreadNum;

@end


