//
//  CarShopDetailsModel.h
//  motoronline
//
//  Created by Mike on 16/1/27.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
///  商家详情
@interface CarShopDetailsModel : NSObject

// 9057
@property (nonatomic, copy) NSString *res_code;
// 返回编号
@property (nonatomic, copy) NSString *res_num;
// 具体消息描述
@property (nonatomic, copy) NSString *res_desc;

///  商家ID
@property (nonatomic, strong) NSNumber *merID;
// 商家名称
@property (nonatomic, copy) NSString *merName;
// 缩略图地址
@property (nonatomic, copy) NSString *imageUrl;
// 地址
@property (nonatomic, copy) NSString *address;
// 经度
@property (nonatomic, copy) NSString *lng;
// 纬度
@property (nonatomic, copy) NSString *lat;
// 离我多少千米
@property (nonatomic, copy) NSString *distance;
// 联系电话
@property (nonatomic, copy) NSString *mobile;
// 关注人数
@property (nonatomic, strong) NSNumber *followNum;
// 在售商品数量
@property (nonatomic, strong) NSNumber *saleGoodsNum;
// 在售新车数量
@property (nonatomic, strong) NSNumber *saleNewCarNum;

@end
