//
//  ShopCollectionModel.h
//  YouCheLian
//
//  Created by Mike on 16/3/24.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCollectionModel : NSObject

// id  去到详情需要
@property (nonatomic, strong) NSNumber *ID;
// 营业时间
@property (nonatomic, copy) NSString *worktime;
// 缩略图
@property (nonatomic, copy) NSString *imgUrl;
// 订金
@property (nonatomic, copy) NSString *pPrice;
// 指导价
@property (nonatomic, copy) NSString *oPrice;
// 时间
@property (nonatomic, copy) NSString *time;
// 0=商品，1=新车，2=活动，3=商家
@property (nonatomic, strong) NSNumber *type;
// 商品url
@property (nonatomic, copy) NSString *linkUrl;
// 商家地址
@property (nonatomic, copy) NSString *address;
// 名称（商家名称，资讯标题，产品名称）
@property (nonatomic, copy) NSString *name;
// 已售个数(暂时都为0)
@property (nonatomic, copy) NSString *saleNum;

// 好评率
@property (nonatomic, strong) NSNumber *goodsNum;

@end
