//
//  DefaultWebController.h
//  YouCheLian
//
//  Created by Mike on 15/12/6.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "BaseViewController.h"
/// Web 控制器都默认用这个
@interface DefaultWebController : BaseViewController

@property(nonatomic, strong) UIWebView *webView;
// http 路径
@property(nonatomic, strong) NSString *urlStr;

/// 返回按钮   NO默认显示    YES 隐藏
@property (nonatomic,assign) BOOL leftBarbuttonHidden;

/// tabbar底部选项栏高度约束  NO默认隐藏    YES 显示
@property (nonatomic,assign) BOOL isShowTabBar;

@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

@end
