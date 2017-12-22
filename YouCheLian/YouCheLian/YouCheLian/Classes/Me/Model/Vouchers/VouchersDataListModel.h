//
//  CollDataListModel.h
//  YouCheLian
//
//  Created by Mike on 15/11/28.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VouchersDataListModel : NSObject

/// 1=店铺，2=商品，3=资讯
@property (nonatomic, assign) int type;
/// 缩略图
@property (nonatomic, copy) NSString *imgUrl;
/// 好评率
@property (nonatomic, assign) int goodsNum;
/// 去到详情需要
@property (nonatomic, assign) int id;

/// 名称（商家名称，资讯标题，产品名称）
@property (nonatomic, copy) NSString *name;
/// 已售个数(暂时都为0)
@property (nonatomic, copy) NSString *saleNum;
/// 原价
@property (nonatomic, copy) NSString *oPrice;
/// 现价
@property (nonatomic, copy) NSString *pPrice;
/// 时间
@property (nonatomic, copy) NSString *time;
/// 商品url
@property (nonatomic, copy) NSString *linkUrl;

//+(instancetype)appWithDict:(NSDictionary *)dict;
//
//-(instancetype)initWithDict:(NSDictionary *)dict;

@end
