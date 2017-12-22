//
//  VoucherModel.h
//  motoronline
//
//  Created by Mike on 16/1/4.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
// 商家代金券
@interface VoucherModel : NSObject

// 代金券id
@property (nonatomic, assign) NSInteger VoId;
// 代金券标题
@property (nonatomic, copy) NSString *title;
// 代金券到期时间
@property (nonatomic, copy) NSString *time;
// 面值
@property (nonatomic, assign) double money;
// 描述
@property (nonatomic, copy) NSString *content;
// 状态0未领取，1已领取
@property (nonatomic, assign) NSInteger state;
@end
