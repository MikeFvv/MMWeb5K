//
//  DeviceWebViewController.m
//  YouCheLian
//
//  Created by Mike on 16/3/21.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "DeviceWebViewController.h"
#import "HMScannerController.h"
#import "LoginViewController.h"
#import "YHNavigationController.h"

@interface DeviceWebViewController ()<UIWebViewDelegate>
{
    /// 是一个旋转进度轮，可以用来告知用户有一个操作正在进行中
    UIActivityIndicatorView *_activityView;
}

@property (assign ,nonatomic) BOOL flage;

@property (nonatomic, copy) NSString *strValue;

//加载的网址
@property (nonatomic, copy) NSString *urlString;

@end

@implementation DeviceWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 隐藏 返回按钮
    if (self.leftBarbuttonHidden) {
        
        self.navigationItem.leftBarButtonItem = nil;
    }

    [self initViews];
    
    //更改系统状态栏的颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRed:0.969  green:0.969  blue:0.969 alpha:1];
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    self.webView.scrollView.bounces = NO;
    

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.webView.delegate = self;
    
    self.navigationController.navigationBar.hidden = YES;
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.webView.delegate = nil;
    
}

-(void)initViews{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight - kUINavHeight)];
    
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    //    NSString *urlStr =  [[GetUrlString sharedManager]urlWithRushBuyWebData];
    if (self.urlStr != nil) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
        [self.webView loadRequest:request];
    } else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
        label.text = @"加载失败...";
        [label setTextColor:[UIColor redColor]];
        label.font = YHFont(16, NO);;
        label.backgroundColor = kGreenColor;
        [self.view addSubview:label];
    }
    
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-15, kUIScreenHeight/2-15, 30, 30)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityView.hidesWhenStopped = YES;
    [self.view addSubview:_activityView];
    [self.view bringSubviewToFront:_activityView];
}




#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{

    
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = theTitle;
    [_activityView stopAnimating];
    
//    if (self.flage == YES) {
//        //OC调用JS
//        NSString *str = [NSString stringWithFormat:@"fn_ReturnUserByIos(%@, 0,1)",[YHUserInfo shareInstance].uPhone ? [YHUserInfo shareInstance].uPhone : @"null" ];
//        YHLog(@"%@",str);
//        [webView stringByEvaluatingJavaScriptFromString:str];
//        self.flage = NO;
//    }
    
    
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    if ([urlString isEqualToString:@"http://www.yholink.com:8082/html/default.htm"]){
//        self.flage = YES;
//    }
    
    NSLog(@"urlString=%@",urlString);
    NSArray *urlComps = [urlString componentsSeparatedByString:@":///"]; // 本地测试用  ://
    
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
    {
        //  objc://getParam1:withParam2:$|我来自ios苹果$|我来自earth地球
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@"$|"];  // 本地测试用  :/
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        
        if (1 == [arrFucnameAndParameter count])
        {
            // 没有参数
            if([funcStr isEqualToString:@"SmImei"])
            {
                /*调用本地函数1*/
                [self SmImei];
                
            }
        }
        else
        {
            //有参数的
            if([funcStr isEqualToString:@"getParam1:withParam2:"])
            {
                // 走到这里调用oc 方法就成功了
                //                [self getParam1:[arrFucnameAndParameter objectAtIndex:1] withParam2:[arrFucnameAndParameter objectAtIndex:2]];
            }
        }
        return NO;
    }
    
    [_activityView startAnimating];
    return YES;
}

- (void)SmImei {
    
    if ([YHUserInfo shareInstance].isLogin) {
        
        [self ScanQRcode];
        
    }else{
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.loginOrReg = YES;
        YHNavigationController *loginView = [[YHNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginView animated:YES completion:nil];
        [self showMessage:LoginTipMessage delay:1];
    }
 
}

//扫描二维码
- (void)ScanQRcode {
    
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        
        self.strValue  = stringValue;
        
        [self.navigationController popViewControllerAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (self.strValue != nil){
                NSString *str = [NSString stringWithFormat:@"fn_SetAddTerminal(%@)", self.strValue];
                [self.webView stringByEvaluatingJavaScriptFromString:str];
                
            }
            
        });
        
        
    }];
    
    [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
    
    [self showDetailViewController:scanner sender:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
