//
//  PersonalInfoEditController.h
//  YouCheLian
//
//  Created by Mike on 15/12/4.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "BaseViewController.h"
#import "PersonalInfoModel.h"


@protocol PersonalInfoEditControllerDelegate <NSObject>

- (void)backPersonalInfoDelegate:(NSDictionary *)dict;

@end

// 个人资料编辑
@interface PersonalInfoEditController : BaseViewController

@property (nonatomic, strong) PersonalInfoModel *personalInfoModel;

@property (nonatomic, weak) id<PersonalInfoEditControllerDelegate> delegate;

@end
