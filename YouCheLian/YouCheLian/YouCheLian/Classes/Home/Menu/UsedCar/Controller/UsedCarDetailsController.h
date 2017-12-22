//
//  UsedCarDetailsController.h
//  YouCheLian
//
//  Created by Mike on 16/3/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class UsedCarModel;
///  二手车详情
@interface UsedCarDetailsController : BaseViewController

@property (nonatomic, strong) UsedCarModel *usedCarModel;
@end
