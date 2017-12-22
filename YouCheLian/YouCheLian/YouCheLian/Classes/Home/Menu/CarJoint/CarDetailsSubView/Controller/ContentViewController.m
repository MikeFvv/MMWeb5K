//
//  ContentViewController.m
//  motoronline
//
//  Created by Mike on 16/1/30.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()<UIWebViewDelegate>
{
    /// 是一个旋转进度轮，可以用来告知用户有一个操作正在进行中
    UIActivityIndicatorView *_activityView;
}

@property (nonatomic, strong) UILabel *label;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNav];
    [self initViews];
    [self headerRefresh];
}


#pragma mark - setter && getter
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight - 64 - 44)];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)setHtmlStr:(NSString *)htmlStr {
    _htmlStr = htmlStr;
    
    if (htmlStr != nil && ![htmlStr isEqualToString:@""]) {
        self.label.hidden = YES;
    }else{
        self.label.hidden = NO;
        [self.view bringSubviewToFront:self.label];
    }
    //这个方法需要将html文件读取为字符串，其中baseURL是我们自己设置的一个路径，用于寻找html文件中引用的图片等素材
    [self.webView loadHTMLString:htmlStr baseURL:nil];
    
    
}




#pragma mark - 下拉刷新数据
- (void)headerRefresh
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.webView.scrollView.mj_header = refreshHeader;
    
    [refreshHeader setTitle:@"下拉回到图文详情" forState:MJRefreshStateIdle];
    [refreshHeader setTitle:@"释放回到图文详情" forState:MJRefreshStatePulling];
    [refreshHeader setTitle:@"释放回到图文详情" forState:MJRefreshStateRefreshing];
    [refreshHeader setTitle:@"释放回到图文详情" forState:MJRefreshStateWillRefresh];
    [refreshHeader setTitle:@"下拉回到图文详情" forState:MJRefreshStateNoMoreData];
}

#pragma mark - 下拉刷新 数据处理相关
- (void)loadNewData
{
    if ([self.delegate respondsToSelector:@selector(downRefreshContent)]) {
        [self.delegate downRefreshContent];
    }
    [self.webView.scrollView.mj_header endRefreshing];
}



- (void)viewWillAppear:(BOOL)animated {
    // 显示隐藏导航栏
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.086  green:0.706  blue:0.325 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}


-(void)setNav {
    // Nav 返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = kNav_Back_CGRectMake;
    [backBtn setImage:[UIImage imageNamed:@"bg_return_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}


-(void)initViews{


    UILabel *label = [[UILabel alloc] init];
    //        label.center = self.view.center;
    label.text = @"暂无数据...";
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextColor:[UIColor lightGrayColor]];
    label.font = YHFont(16, NO);;
    //        label.backgroundColor = kGreenColor;
    [self.view addSubview:label];
    self.label = label;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
}

-(void)onBackBtn:(UIButton *)sender {
    // 将栈顶的控制器移除
    [self.navigationController popViewControllerAnimated:YES];
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
    
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = theTitle;
    [_activityView stopAnimating];
}



@end
