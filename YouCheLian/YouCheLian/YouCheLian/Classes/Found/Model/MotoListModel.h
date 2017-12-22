//
//  MotoListModel.h
//  YouCheLian
//
//  Created by Mike on 15/12/11.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MotoListModel : NSObject


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

/// 新车简介
@property (nonatomic, copy) NSString *sketch;


@end
