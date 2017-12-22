//
//  ReceivingAddressModel.h
//  YouCheLian
//
//  Created by Mike on 15/11/24.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceivingAddressModel : NSObject


// id
@property (nonatomic, strong) NSNumber *ID;
// 省份Id
@property (nonatomic, copy) NSString *provinceid;
// 城市Id
@property (nonatomic, copy) NSString *cityid;
// 区域Id
@property (nonatomic, copy) NSString *areaid;
// 姓名
@property (nonatomic, copy) NSString *name;
// 联系电话
@property (nonatomic, copy) NSString *linkPhone;
// 地址
@property (nonatomic, copy) NSString *address;
// 是否为默认
@property (nonatomic, strong) NSNumber *isDefault;
// 邮编
@property (nonatomic, copy) NSString *zipcode;

@property (nonatomic, assign) CGFloat cellHeight;

/**
 *  快速创建一个模型对象
 *
 */
//+(instancetype)appWithDict:(NSDictionary *)dict;

@end
