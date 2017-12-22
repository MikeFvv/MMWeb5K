//
//  CarJointDetailsController.h
//  YouCheLian
//
//  Created by Mike on 16/3/4.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "BaseViewController.h"

@interface CarJointDetailsController : BaseViewController
///  商品id
@property (nonatomic, copy) NSString *carId;
///   0=商城,1=新车，2=活动车
@property (nonatomic, copy) NSString *type;

@end
