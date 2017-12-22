//
//  DeviceWebViewController.h
//  YouCheLian
//
//  Created by Mike on 16/3/21.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "BaseViewController.h"

@interface DeviceWebViewController : BaseViewController

@property(nonatomic, strong) UIWebView *webView;
// http 路径
@property(nonatomic, strong) NSString *urlStr;

/// 返回按钮   NO默认显示    YES 隐藏
@property (nonatomic,assign) BOOL leftBarbuttonHidden;

@end
