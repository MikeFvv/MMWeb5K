//
//  FoundCarDetailsViewController.h
//  YouCheLian
//
//  Created by Mike on 16/3/5.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "BaseViewController.h"

@interface FoundCarDetailsViewController : BaseViewController
///  商品id
@property (nonatomic, copy) NSString *carId;
///   0=商城,1=新车，2=活动车
@property (nonatomic, copy) NSString *type;

@end
