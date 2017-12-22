//
//  MeSystemMessageDetailsController.m
//  YouCheLian
//
//  Created by Mike on 16/3/24.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "MeSystemMessageDetailsController.h"

@interface MeSystemMessageDetailsController ()<UIWebViewDelegate>
{
    /// 是一个旋转进度轮，可以用来告知用户有一个操作正在进行中
    UIActivityIndicatorView *_activityView;
}

@end

@implementation MeSystemMessageDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initViews];
    
    [self.webView loadHTMLString:self.model.content baseURL:nil];
    
    self.title = self.model.title;
}

-(void)initViews{
    //    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight-64)];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight - 64)];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    //    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-15, kUIScreenHeight/2-15, 30, 30)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityView.hidesWhenStopped = YES;
    [self.view addSubview:_activityView];
    [self.view bringSubviewToFront:_activityView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //设置webView的字体大小
    NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@%%'", @(250)]; //大小为1.25倍
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
    
//    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    self.title = theTitle;
    [_activityView stopAnimating];
}


@end
