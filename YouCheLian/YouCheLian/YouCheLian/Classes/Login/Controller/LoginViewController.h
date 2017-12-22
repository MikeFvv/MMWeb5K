//
//  DSLoginViewController.h
//  YouCheLian
//
//  Created by Mike on 15/11/4.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "BaseViewController.h"

// 登录成功 回调
typedef void (^LoginSuccessBlock)();

@interface LoginViewController : BaseViewController

// YES登录   NO注册 
@property (nonatomic, assign) BOOL loginOrReg;

// 登录成功 回调
@property (nonatomic, copy) LoginSuccessBlock loginSuccessBlock;

@end
