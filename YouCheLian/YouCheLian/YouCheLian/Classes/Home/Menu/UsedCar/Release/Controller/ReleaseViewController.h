//
//  ReleaseViewController.h
//  YouCheLian
//
//  Created by Mike on 16/3/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "BaseViewController.h"
#import "UsedCarModel.h"

// 发布成功 回调
typedef void (^ReleaseSuccessBlock)();

@interface ReleaseViewController : BaseViewController

///  YES 为编辑  NO 为新增
@property (nonatomic, assign) BOOL isEdit;
//
@property (nonatomic,copy) NSString *releaseType;
//model存在为编辑
@property (nonatomic, strong) UsedCarModel *model;

@property (nonatomic, copy) ReleaseSuccessBlock releaseSuccessBlock;

@end
