//
//  BuyCarController.m
//  YouCheLian
//
//  Created by Mike on 15/12/5.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "DefaultWebController.h"
#import "CarJointDetailsController.h"
#import "FoundCarDetailsViewController.h"
#import "ShopDetailsTableController.h"
#import "LoginViewController.h"
#import "YHNavigationController.h"


@interface DefaultWebController ()<UIWebViewDelegate>
{
    /// 是一个旋转进度轮，可以用来告知用户有一个操作正在进行中
    UIActivityIndicatorView *_activityView;
}

@property (assign ,nonatomic) BOOL flage;
@property (assign ,nonatomic) float tabBarHeight;


@end

@implementation DefaultWebController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // 在push控制器时隐藏UITabBar
        //        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    [self setNav];
    [self initViews];
    
    
}

/// 初始化数据  重要  - 需优先调用
- (void)initData {
    
    // 隐藏 返回按钮
    if (self.leftBarbuttonHidden) {
        
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    // 显示 tabBar
    if (_isShowTabBar == YES) {
        _tabBarHeight = kUITabBarHeight;
    } else {
        _tabBarHeight = 0;
    }
    
    self.flage = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.webView.delegate = self;
    
    self.navigationController.navigationBar.hidden = NO;
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.webView.delegate = nil;
    
}

-(void)setNav {
    
    //    // Nav 返回
    //    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    backBtn.frame = kNav_Back_CGRectMake;
    //    [backBtn setImage:[UIImage imageNamed:@"nav_back_2"] forState:UIControlStateNormal];
    //    [backBtn addTarget:self action:@selector(onBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    if (self.rightBarButtonItem != nil) {
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    }
    // Nav 返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = kNav_Back_CGRectMake;
    
    //    // 返回按钮内容左靠
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // 让返回按钮内容继续向左边偏移10
    //    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    
    [backBtn setImage:[UIImage imageNamed:@"Search_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

-(void)onBackBtn:(UIButton *)sender {
    
    if ([self.webView canGoBack]){
        [self.webView goBack];
    }else {
        // 在push控制器时显示UITabBar
        self.hidesBottomBarWhenPushed = NO;
        // 将栈顶的控制器移除
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



-(void)initViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight - kUINavHeight - self.tabBarHeight)];
    
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
        label.text = @"网络故障，界面加载失败...";
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
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (!self.title){
        NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.title = theTitle;
    }
    
    [_activityView stopAnimating];
    if (self.flage == YES) {
        //OC调用JS
        //[webView stringByEvaluatingJavaScriptFromString:@"show(1212)"];
        self.flage = NO;
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
            if([funcStr isEqualToString:@"doFunc1"])
            {
                
                /*调用本地函数1*/
                NSLog(@"doFunc1");
                
            }
        }
        else
        {
            //有参数的
            //登录跳转
            if([funcStr isEqualToString:@"getParam1:withParam2:"])
            {
                // 走到这里调用oc 方法就成功了
                //                [self getParam1:[arrFucnameAndParameter objectAtIndex:1] withParam2:[arrFucnameAndParameter objectAtIndex:2]];
                [self fn_getParam1:[arrFucnameAndParameter objectAtIndex:1]];
            }
            if([funcStr isEqualToString:@"fn_ViewProdcutDetail:withParam2:"])
            {
                
                [self fn_ViewProdcutDetail:[arrFucnameAndParameter objectAtIndex:1]];
                
            }
            if([funcStr isEqualToString:@"fn_ShowMoto:withParam1:"])
            {
                
                [self fn_ShowMoto:[arrFucnameAndParameter objectAtIndex:1]];
                
            }
            if([funcStr isEqualToString:@"fn_ToMerById:withParam2:"])
            {
                
                [self fn_ToMerById:[arrFucnameAndParameter objectAtIndex:1]];
                
            }
        }
        return NO;
    }
    
    [_activityView startAnimating];
    return YES;
}
//跳转商品详情
- (void)fn_ViewProdcutDetail:(NSString *)ID {
    //商品详情
    CarJointDetailsController *vc = [[CarJointDetailsController alloc] init];
    vc.carId = ID;
    vc.type = @"0"; ///   0=商城,1=新车，2=活动车
    [self.navigationController pushViewController:vc animated:YES];
    
}

//检查是否登录
- (void)fn_getParam1:(NSString *)url {
    
    if ([YHUserInfo shareInstance].isLogin) {
        
        NSString *jumpUrl = [YHFunction joDesaccountPassWordUrl:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:jumpUrl]];
        [self.webView loadRequest:request];
        
    }else {
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.loginOrReg = YES;
        YHNavigationController *loginView = [[YHNavigationController alloc] initWithRootViewController:loginVC];
        loginVC.loginSuccessBlock = ^{
            
            NSString *jumpUrl = [YHFunction joDesaccountPassWordUrl:url];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:jumpUrl]];
            
            [self.webView loadRequest:request];
            
        };
        
        [self presentViewController:loginView animated:YES completion:nil];
        [self showMessage:LoginTipMessage delay:1];
    }
    
    
}
//跳转车辆详情
-(void)fn_ShowMoto:(NSString *)ID {
    //车辆详情
    FoundCarDetailsViewController *vc = [[FoundCarDetailsViewController alloc] init];
    self.tabBarController.tabBar.hidden = YES;
    vc.carId = ID;
    vc.type = @"2"; ///   0=商城,1=新车，2=活动车
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
//跳转商家详情
-(void)fn_ToMerById:(NSString *)ID {
    
    YHLog(@"sdfdsf");
    
    // 商家详情
    ShopDetailsTableController *vc = [[ShopDetailsTableController alloc] init];
    [vc setHidesBottomBarWhenPushed:YES];
    //    vc.title = model.merchName;
    vc.shopId = ID;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
