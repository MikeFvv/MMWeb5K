//
//  FoundCarContentViewController.m
//  YouCheLian
//
//  Created by Mike on 16/3/5.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FoundCarContentViewController.h"
#import "CarDetailsSubViewDataModel.h"

@interface FoundCarContentViewController ()<UIWebViewDelegate>
{
    /// 是一个旋转进度轮，可以用来告知用户有一个操作正在进行中
    UIActivityIndicatorView *_activityView;
}
@property (nonatomic, strong) CarDetailsSubViewDataModel *dataModel;

@end

@implementation FoundCarContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initViews];
    
    [self getData];
 
    [self headerRefresh];
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

/// 获取推荐车型商品描述数据
- (void)getData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1059" forKey:@"rec_code"];
    [dictParam setValue:self.carId forKey:@"rec_id"]; // 商品Id
    [dictParam setValue:self.type forKey:@"rec_type"]; // 1=新车，2=活动车
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];

    
    YHLog(@"字符串===%@",dictParam);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@",result);
        self.dataModel = [CarDetailsSubViewDataModel mj_objectWithKeyValues:result];
        
        self.htmlStr = self.dataModel.content;
        
        if (self.htmlStr == nil || [self.htmlStr isEqualToString:@""]) {
            UILabel *label = [[UILabel alloc] init];
            //        label.center = self.view.center;
            label.text = @"暂无数据...";
            label.textAlignment = NSTextAlignmentCenter;
            [label setTextColor:[UIColor lightGrayColor]];
            label.font = YHFont(16, NO);;
            //        label.backgroundColor = kGreenColor;
            [self.view addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.view.mas_centerY);
                make.centerX.equalTo(self.view.mas_centerX);
            }];
            
            
        } else {
            //这个方法需要将html文件读取为字符串，其中baseURL是我们自己设置的一个路径，用于寻找html文件中引用的图片等素材
            [self.webView loadHTMLString:self.htmlStr baseURL:nil];
            
            
        }

        //        [self.flipView.tableView reloadData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        // [self.tableView.mj_footer endRefreshing];
        
        [self hidenLoadingView];
        return YES;
    }];
}


#pragma mark - 下拉刷新 数据处理相关
- (void)loadNewData
{
    if ([self.delegate respondsToSelector:@selector(downRefreshContent)]) {
        [self.delegate downRefreshContent];
    }
    [self.webView.scrollView.mj_header endRefreshing];
}


-(void)initViews{
    //    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight-64)];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, kUIScreenHeight - 64 - 44)];
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
    
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = theTitle;
    [_activityView stopAnimating];
}




@end
