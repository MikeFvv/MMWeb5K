//
//  FoundCarDetailsModel.h
//  YouCheLian
//
//  Created by Mike on 16/3/5.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoundCarDetailsModel : NSObject
// 返回编号
@property (nonatomic, copy) NSString *res_num;
// 9056
@property (nonatomic, copy) NSString *res_code;
// 具体消息描述
@property (nonatomic, copy) NSString *res_desc;
/// 车辆名称
@property (nonatomic, copy) NSString *carName;
/// 车辆简述
@property (nonatomic, copy) NSString *sketch;

///// 评价数
//@property (nonatomic, assign) NSInteger evaluateCount;
///// 头像url
//@property (nonatomic, copy) NSString *headUrl;
///// 昵称
//@property (nonatomic, copy) NSString *nickName;
///// 评价内容
//@property (nonatomic, copy) NSString *content;
///// 订单备注（如：颜色：白色，尺码：XL）
//@property (nonatomic, copy) NSString *oderRemark;

// 是否收藏     0=未收藏, 1=已收藏
@property (nonatomic, assign) NSInteger isCollection;

/// 评价时间
@property (nonatomic, copy) NSString *time;
/// 指导价
@property (nonatomic, copy) NSString *price;
/// 市场价
@property (nonatomic, copy) NSString *marketPrice;
/// 定金 定金=0此商品支付活动价，定金>0商品支付为定金
@property (nonatomic, copy) NSString *earnestMoney;
/// 配送方式
@property (nonatomic, copy) NSString *express;

@property (nonatomic, strong) NSArray *colorList;

@property (nonatomic, strong) NSArray *serviceList;


@property (nonatomic, assign) CGFloat cellHeight;
@end
