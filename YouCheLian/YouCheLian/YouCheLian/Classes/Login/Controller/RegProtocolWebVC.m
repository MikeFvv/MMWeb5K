//
//  RegProtocolWebViewController.m
//  YouCheLian
//
//  Created by Mike on 16/3/31.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "RegProtocolWebVC.h"

@interface RegProtocolWebVC ()

@end

@implementation RegProtocolWebVC


/// UIWebView
- (void)loadView {
    self.view = [[UIWebView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.949  green:0.953  blue:0.929 alpha:1];
    [self webViewFile];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    \
}

- (void)webViewFile {
    
    // 加载网页文件
    UIWebView *webView = (UIWebView *)self.view;
    
    // 获得网页文件的全路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"YoLinkRegisterProtocol.htm" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    // 创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}



@end
