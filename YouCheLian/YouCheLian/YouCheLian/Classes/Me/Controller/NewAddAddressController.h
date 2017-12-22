//
//  NewAddAddressController.h
//  YouCheLian
//
//  Created by Mike on 15/12/2.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "BaseViewController.h"

@class ReceivingAddressModel;

// 登录成功 回调
typedef void (^AddressSuccessBlock)();

///  新增  更改  收货地址
@interface NewAddAddressController : BaseViewController

// Id=0为新增，如果id 1为修改
@property (nonatomic, assign) NSInteger isNewAdd;

@property (nonatomic, strong) ReceivingAddressModel *model;

// 登录成功 回调
@property(nonatomic,copy)AddressSuccessBlock addressSuccessBlock;

@end
