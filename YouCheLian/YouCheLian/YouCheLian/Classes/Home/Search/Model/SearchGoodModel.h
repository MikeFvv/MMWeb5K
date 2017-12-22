//
//  SearchGoodModel.h
//  YouCheLian
//
//  Created by Mike on 16/3/15.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchGoodModel : NSObject

/// 商品id
@property (nonatomic, strong) NSNumber *ID;
/// 商品名称
@property (nonatomic, copy) NSString *ProName;
/// 缩略图url
@property (nonatomic, copy) NSString *ImgUrl;
/// 价格1
@property (nonatomic, copy) NSString *Price1;
/// 购买URL
@property (nonatomic, copy) NSString *buyUrl;
/// 描述
@property (nonatomic, copy) NSString *sketch;
/// 支付方式
@property (nonatomic, copy) NSString *PayType;
/// 卖出数量
@property (nonatomic, strong) NSNumber *SaleNum;
/// 价格
@property (nonatomic, copy) NSString *Price;
/// 商品类型  0- 商品 1- 新车
@property (nonatomic, copy) NSString *goodType;

@end
