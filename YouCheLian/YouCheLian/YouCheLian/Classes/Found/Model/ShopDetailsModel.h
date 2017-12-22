//
//  ShopDetailsModel.h
//  YouCheLian
//
//  Created by Mike on 15/12/11.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopDetailsModel : NSObject


// 返回编号
@property (nonatomic, assign) NSInteger res_num;
// 9205
@property (nonatomic, copy) NSString *res_code;
// 对应类型枚举表
@property (nonatomic, copy) NSString *res_desc;
// 商家名称
@property (nonatomic, copy) NSString *mechName;
// 缩略图
@property (nonatomic, copy) NSString *imgUrl;
// 好评率
@property (nonatomic, copy) NSString *goodNum;
// 收藏数
@property (nonatomic, assign) NSInteger collectionNum;
// 评论数
@property (nonatomic, assign) NSInteger commentNum;
// 收藏0=未收藏，1=已收藏
@property (nonatomic, assign) NSInteger isattention;

// 详细地址
@property (nonatomic, copy) NSString *address;
// 详情内容(注意考虑html格式)
@property (nonatomic, copy) NSString *context;
// 经度
@property (nonatomic, copy) NSString *lng;
// 纬度
@property (nonatomic, copy) NSString *lat;
// 电话
@property (nonatomic, copy) NSString *mobile;
// 商家类型10000汽车商家，10001摩托商家
@property (nonatomic, copy) NSString *ShopTypeID;
// 营业时间
@property (nonatomic, copy) NSString *BusinessHours;

//
@property (nonatomic, strong) NSArray *servicelist;
//
@property (nonatomic, strong) NSArray *motolist;
//
@property (nonatomic, strong) NSArray *goodslist;

@property (nonatomic, strong) NSArray *actList;

@end
