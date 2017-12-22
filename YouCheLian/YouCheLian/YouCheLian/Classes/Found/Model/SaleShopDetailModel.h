//
//  SaleShopDetailModel.h
//  motoronline
//
//  Created by Mike on 16/2/22.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaleShopDetailModel : NSObject

// 商家车辆的唯一ID
@property (nonatomic, assign) NSInteger carId;
// 商家车辆名称
@property (nonatomic, copy) NSString *ProName;
// 商家车辆价格
@property (nonatomic, copy) NSString *Price;
// 商家车辆缩略图
@property (nonatomic, copy) NSString *ImgUrl;
// 商家购买URl
@property (nonatomic, copy) NSString *buyUrl;
// 0商品  1新车
@property (nonatomic, copy) NSString *goodType;

/// 新车简介
@property (nonatomic, copy) NSString *sketch;

@end
