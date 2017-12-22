//
//  MeSystemMessageDetailsController.h
//  YouCheLian
//
//  Created by Mike on 16/3/24.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "BaseViewController.h"
#import "MeSystemMessageModel.h"

@interface MeSystemMessageDetailsController : BaseViewController

@property(nonatomic, strong) UIWebView *webView;
// html 字符串
@property(nonatomic, strong) MeSystemMessageModel *model;

@end
