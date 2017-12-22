//
//  HomeViewController.m
//  YouCheLian
//
//  Created by Mike on 15/11/4.
//  Copyright (c) 2015年 Mike. All rights reserved.
//


#import "HomeViewController.h"
#import "YHNavigationController.h"

// 首页功能菜单
#import "GroupTableViewCell.h"
#import "HomeMenuCell.h"

#import <CoreLocation/CoreLocation.h>
#import "YHLocationManager.h"

// 图片轮播器
#import "HomeFocusModel.h"
#import "DataListModel.h"
#import "AdsTableCell.h"
#import <SDCycleScrollView.h>

#import "CityListViewController.h"  // 城市选择
#import "NavigationMenu.h"   /// 下拉菜单类

#import "SCTitleButton.h"  // nav 自定义button
#import "UIButton+CenterImageAndTitle.h"
#import "ImageMallViewCell.h"

// ****菜单****
#import "UsedCarController.h"

// Cell
#import "HomeTitleCell.h"
#import "HomeDiscountCell.h"

// 优惠活动
#import "DefaultWebController.h"
#import "HomeDiscountModel.h"

// Model
#import "HomeDiscountModels.h"
#import "SearchViewController.h"  // 搜索
#import "CarJointShareController.h"  // 分享

// 登录
#import "LoginViewController.h"

#define kTableViewHeaderHeight  40

// 最大请求次数
#define requestCountLimit 9




//mode枚举
typedef enum  {
    APPModeMoto,
    APPModeCar,
} APPMode;


@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,HomeMenuCellDelegate,CityListViewDelegate,AdsTableCellDelegate,GroupTableViewCellDelegate,YHLocationManagerDelegate,UIWebViewDelegate>{
    MBProgressHUD *HUD;
}


@property(nonatomic,strong) CLLocationManager *manager;
@property(nonatomic,strong) CLLocation *location;

@property(nonatomic,strong) UITableView *tableView;

// 城市选择 Button
@property (nonatomic, strong) UIButton *leftCityBtn;
@property (nonatomic, strong) SCTitleButton *cusCityBtn;
/// 下拉菜单类
@property (strong, nonatomic) NavigationMenu *menu;

@property (nonatomic, strong) UIBarButtonItem *loginRegItem;

@property(nonatomic,strong) AdsTableCell *adsCell;

//============================================
@property (nonatomic, strong) HomeFocusModel *homeFocusModel;
///首页顶部广告数据模型
@property (nonatomic, strong) DataListModel *topImageModel;
@property (nonatomic, strong) NSArray *homeFocusArray;
@property (nonatomic, strong) NSMutableArray *homeFocusImgUrlArray;

/// tableHeaderView 图片数据
@property(nonatomic,strong)NSArray *collArray;

// 请求次数
@property (nonatomic, assign) NSInteger requestCountMark;

@property (nonatomic, strong) HomeDiscountModels *homeDiscountModels;
@property (nonatomic, strong) NSMutableArray *brandArray;

// 搜索
@property (nonatomic, strong) UISearchBar *searchBar;
//
@property (nonatomic, assign) APPMode currentMode;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageIndex = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    // 设置首页导航栏
    [self setNav];
    // 定位通知
    [self initNotification];
    
    [self dispatchGroup];
    [self setDownTableView];  // 下拉刷新
    //    [self footerRefresh]; //  上拉加载 只显示3条数据不需要上拉加载
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 12)];
    line.backgroundColor = [UIColor colorWithRed:0.953  green:0.957  blue:0.961 alpha:1];
    
    self.tableView.tableFooterView = line;
    
    // 注册cell
    [self.tableView registerClass:[HomeDiscountCell class] forCellReuseIdentifier:@"HomeDiscountCell"];
    
    // 发送通知 开启定位
    [[NSNotificationCenter defaultCenter]postNotificationName:OpeningPositioning object:nil];
    
    //创建webView
    [self setupWebView];
    
}

#pragma mark --  创建webView
- (void)setupWebView {
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
//    webView.backgroundColor = [UIColor redColor];
    webView.hidden = YES;
    webView.scrollView.scrollEnabled = NO;
    [self.view addSubview:webView];
    self.webView = webView;
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-49);
    }];
    
    
    
}

- (void)initNotification {
    // 位置信息管理
    [YHLocationManager shareInstance].delegate = self;
    
    // 注册定位通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationAction) name:OpeningPositioning object:nil];
    
    // 重新登录 跳转到登录页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLoginAction) name:ReLoginNotification object:nil];
}


#pragma mark - 开启定位
- (void)locationAction {
    // 开启定位
    [[YHLocationManager shareInstance] startLocation];
}


#pragma mark - 重新登录 跳转到登录页面
// 重新登录 跳转到登录页面
- (void)reLoginAction {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.loginOrReg = YES;
    YHNavigationController *loginView = [[YHNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginView animated:YES completion:nil];
}




- (void)dealloc {
    // 移除指定通知
    
    // 参数1: 监听对象  参数2: 监听名称  参数3: 通知发送者
    // 注册定位通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OpeningPositioning object:nil];
    // 重新登录
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReLoginNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - 初始化 tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kUIScreenWidth,kUIScreenHeight - kUITabBarHeight - kUINavHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 隐藏分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        //去掉下面没有数据呈现的cell
        _tableView.tableFooterView = [[UIView alloc]init];
        //隐藏滚动条
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

#pragma mark - YHLocationManagerDelegate 定位

-(void)YHLocationManager:(YHLocationManager *)manager changeCurrentCity:(NSString *)cityName{
    
    [UserDefaultsTools setObject:cityName forKey:kCityName];
    
    [_cusCityBtn setTitle:cityName forState:UIControlStateNormal];
}

#pragma mark - 调度组
///  调度组
- (void)dispatchGroup {
    _requestCountMark = 0;
    //  群组－统一监控一组任务
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    
    [self showLoadingView];
    // 添加任务
    // group 负责监控任务，queue 负责调度任务
    dispatch_group_async(group, q, ^{
        // 设置线程阻塞1，阻塞2秒  // 暂停1s 的意思
        // 加载广告图数据
        [self getFocusData];
        NSLog(@"任务1 %@", [NSThread currentThread]);
    });
    dispatch_group_async(group, q, ^{
        [self getDiscountData]; // 优惠推荐
        NSLog(@"任务2 %@", [NSThread currentThread]);
    });
    dispatch_group_async(group, q, ^{
        [self getTopFocusData]; // 加载顶部广告数据
        NSLog(@"任务3 %@", [NSThread currentThread]);
    });
    
    
    
    // 监听所有任务完成 － 等到 group 中的所有任务执行完毕后，"由队列调度 block 中的任务异步执行！"
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 修改为主队列，后台批量下载，结束后，主线程统一更新UI
        [self hidenLoadingView];
        NSLog(@"任务OK %@", [NSThread currentThread]);
    });
    NSLog(@"come here");
}




/// 懒加载应用信息
///
/// @return tableHeaderView 数组数据
- (NSArray *)collArray {
    if(_collArray == nil) {
        _collArray = [GroupCollectionViewModel modelData];
    }
    return _collArray;
}

- (AdsTableCell *)adsCell {
    if (_adsCell == nil) {
        _adsCell = [[[NSBundle mainBundle]loadNibNamed:@"AdsTableCell" owner:nil options:nil]lastObject];
        _adsCell.frame = CGRectMake(0, 5, kUIScreenWidth, 128);
        // 把图片数组传过去
        
    }
    _adsCell.imgArray = _homeFocusImgUrlArray;
    return _adsCell;
}

#pragma mark UITableView + 下拉刷新
- (void)setDownTableView {
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    self.tableView.mj_header = refreshHeader;
    
    [refreshHeader setTitle:@"优宝君正在刷新中，请主人稍安勿躁 " forState:MJRefreshStateRefreshing];}


-(void)loadNewData {
    _requestCountMark = 0;
    //  群组－统一监控一组任务
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    // 添加任务
    // group 负责监控任务，queue 负责调度任务
    dispatch_group_async(group, q, ^{
        // 设置线程阻塞1，阻塞2秒  // 暂停1s 的意思
        [NSThread sleepForTimeInterval:1.0];
        // 加载数据
        [self getFocusData];
    });
    dispatch_group_async(group, q, ^{
        [self getDiscountData]; // 优惠推荐
    });
    dispatch_group_async(group, q, ^{
        [self getTopFocusData]; // 加载顶部广告数据
        
    });
    
    // 监听所有任务完成 － 等到 group 中的所有任务执行完毕后，"由队列调度 block 中的任务异步执行！"
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 修改为主队列，后台批量下载，结束后，主线程统一更新UI
        [self.tableView.mj_header endRefreshing];
    });
}




#pragma mark - 设置导航条
- (void)setNav {
    
    self.navigationController.navigationBarHidden = NO;
    
    // 城市显示及 图标
    _cusCityBtn = [[SCTitleButton alloc] init];
    // 图标是否在button 右边
    _cusCityBtn.moveImageToRight = YES;
    _cusCityBtn.frame = CGRectMake(0, 0, 80, 25);
    
    [_cusCityBtn setImage:[UIImage imageNamed:@"nav_down"] forState:UIControlStateNormal];
    [_cusCityBtn setImage:[UIImage imageNamed:@"nav_up"] forState:UIControlStateHighlighted];
    
    
    if ([UserDefaultsTools stringForKey:kCityName]) {
        [_cusCityBtn setTitle:[UserDefaultsTools stringForKey:kCityName] forState:UIControlStateNormal];//如何修改
    }else{
        [_cusCityBtn setTitle:@"未知" forState:UIControlStateNormal];
    }
    
    _cusCityBtn.titleFont = YHFont(16, NO);
    // 设置Nav LeftBtn 字体颜色
    _cusCityBtn.titleColor = [UIColor colorWithRed:0.463  green:0.467  blue:0.471 alpha:1];
    
    [_cusCityBtn addTarget:self action:@selector(cityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_cusCityBtn];
    
    //切换汽车版
//    UIBarButtonItem *modeBtn = [[UIBarButtonItem alloc] initWithTitle:@"切换汽车版" style:UIBarButtonItemStyleDone target:self action:@selector(modeBtnClick:)];
//    
//    [modeBtn setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],
//                                      NSForegroundColorAttributeName:kGlobalColor} forState:UIControlStateNormal
//     ];
    
    UIBarButtonItem *modeBtn = [[UIBarButtonItem alloc] initWithTitle:@"          " style:UIBarButtonItemStyleDone target:self action:@selector(NoData)];
    
    [modeBtn setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                      NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal
     ];
    
    self.navigationItem.rightBarButtonItem = modeBtn;
    
    
    
    /********** 中间搜索视图 ***********/
    UIView *navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth*1, 30)];
    navBgView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = navBgView;
    
    // 搜索框
    UIView *searchView = [[UIView alloc] init];
    searchView.layer.cornerRadius = 30 / 2;
    searchView.layer.borderWidth = 1;
    searchView.layer.borderColor = [UIColor colorWithRed:0.588  green:0.776  blue:0.145 alpha:1].CGColor;
    
    //创建一个点击手势对象，该对象可以调用handelTap：方法
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchActionTap:)];
    [searchView addGestureRecognizer:tapGes];
    //    [tapGes setNumberOfTouchesRequired:1];  //触摸点个数
    //    [tapGes setNumberOfTapsRequired:1]; //点击次数
    
    [navBgView addSubview:searchView];
    
    UIImageView *iconImag = [[UIImageView alloc] init];
    iconImag.image = [UIImage imageNamed:@"nav_search"];
    [searchView addSubview:iconImag];
    
    // 搜索框
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(navBgView.mas_left).with.offset(10);
        make.right.mas_equalTo(navBgView.mas_right).with.offset(-5);
        make.centerY.mas_equalTo(navBgView.mas_centerY);
        make.height.mas_equalTo(navBgView.mas_height);
    }];
    
    // 放大镜图标
    [iconImag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(searchView.mas_left).offset(12);
        make.centerY.mas_equalTo(searchView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
}

///  无操作
- (void)NoData {
    
}

#pragma mark - 搜索跳转
/// 跳转搜索控制器
- (void)searchActionTap:(UITapGestureRecognizer *)tgp {
    //搜索
    SearchViewController *searchVc = [[SearchViewController alloc] init];
    //        self.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:searchVc animated:YES];
}

#pragma mark - 切换模式按钮
-(void) modeBtnClick:(UIButton *)btn{
    
    if(self.currentMode == APPModeMoto){
        
//        GroupCollectionViewModel *model = self.collArray[0];
//        
//#pragma mark  -更换图片
//        model.icon = @"activity_icon";//需要更换对应的图片
//        
//        GroupCollectionViewModel *model1 = self.collArray[1];
//        model1.icon = @"home_ershouche";
//        model1.enble = NO;
//        
//        GroupCollectionViewModel *model2 = self.collArray[3];
//        model2.enble = NO;
        
//        self.webView.hidden = NO;
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://yholink.com:9091/html/index.html"]]];
//        self.currentMode = APPModeCar;
        
//        [self.navigationItem.rightBarButtonItem setTitle:@"切换机车版"];
        
    }else if(self.currentMode == APPModeCar){
        
//        GroupCollectionViewModel *model = self.collArray[0];
//        model.icon = @"activity_icon";
//        
//        GroupCollectionViewModel *model1 = self.collArray[1];
//        model1.icon = @"home_ershouche";
//        model1.enble = YES;
//        
//        GroupCollectionViewModel *model2 = self.collArray[3];
//        model2.enble = YES;
        self.webView.hidden = YES;
        self.currentMode = APPModeMoto;
        
//        [self.navigationItem.rightBarButtonItem setTitle:@"切换汽车版"];
        
    }
//
//    [self.tableView reloadData];
}

#pragma mark - 菜单登录 注册 搜索
- (NavigationMenu *)menu {
    if (!_menu) {
        MenuButton *loginBtn = [[MenuButton alloc] initWithTitle:@"登录" buttonIcon:[UIImage imageNamed:@""]];
        MenuButton *regBtn = [[MenuButton alloc] initWithTitle:@"注册" buttonIcon:[UIImage imageNamed:@""]];
        _menu = [[NavigationMenu alloc] initWithItems:@[loginBtn, regBtn]];
    }
    return _menu;
}




#pragma mark - 城市 选择
///  城市 选择
-(void)cityBtnClick:(UIButton *)button {
    //    button.selected = !button.selected;
    
    CityListViewController *cityListView = [[CityListViewController alloc]init];
    cityListView.delegate = self;
    //热门城市列表
    cityListView.arrayHotCity = [NSMutableArray arrayWithObjects:@"广州",@"北京",@"天津",@"厦门",@"重庆",@"福州",@"泉州",@"济南",@"深圳",@"长沙",@"无锡", nil];
    //历史选择城市列表
    cityListView.arrayHistoricalCity = [NSMutableArray arrayWithObjects:@"福州",@"厦门",@"泉州", nil];
    //定位城市列表
    NSString *cityName = [[YHLocationManager shareInstance] getCityName];
    cityListView.arrayLocatingCity   = [NSMutableArray arrayWithObjects:cityName, nil];
    
    [self presentViewController:cityListView animated:YES completion:nil];
    
}

// 城市名选择回调方法
- (void)didClickedWithCityName:(NSString*)cityName
{
    NSString *str;
    // 城市名大于4个字符 就拼接
    if (cityName.length > 4) {
        str = [NSString stringWithFormat:@"%@...",[cityName substringToIndex:4] ];
    }
    [_cusCityBtn setTitle:str > 0 ? str : cityName forState:UIControlStateNormal];
    
    [UserDefaultsTools setObject:str > 0 ? str : cityName forKey:kCityName];
    
}


#pragma mark -  首页广告 请求数据

/// 首页顶部广告图数据
- (void)getTopFocusData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1020" forKey:@"rec_code"];
    [dictParam setValue:@"1" forKey:@"rec_id"];
    
    // [NSString stringWithFormat:@"%ld",[YHUserInfo shareInstance].terminaType]
    [dictParam setValue:@"5" forKey:@"rec_type"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@", result);
        if (error) {
            YHLog(@"测试");
            if (self.requestCountMark < requestCountLimit) {
                self.requestCountMark++;
                [self getTopFocusData];
                return NO;
            } else {
                [self hidenLoadingView];
            }
        } else {
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                HomeFocusModel *homeFocusModel  = [HomeFocusModel appWithDict:result];
                self.topImageModel = homeFocusModel.dataList[0];
                
                
                [self.tableView reloadData];
                
            }else {
                //                [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            }
        }
        return YES;
    }];
}

/// 首页中部广告图数据
- (void)getFocusData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1020" forKey:@"rec_code"];
    [dictParam setValue:@"2" forKey:@"rec_id"];
    
    //    [NSString stringWithFormat:@"%ld",[YHUserInfo shareInstance].terminaType]
    [dictParam setValue:@"5" forKey:@"rec_type"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@", result);
        if (error) {
            YHLog(@"测试");
            if (self.requestCountMark < requestCountLimit) {
                self.requestCountMark++;
                [self getFocusData];
                return NO;
            } else {
                [self hidenLoadingView];
            }
        } else {
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                _homeFocusModel  = [HomeFocusModel appWithDict:result];
                _homeFocusArray = _homeFocusModel.dataList;
                
                // 获取图片url
                _homeFocusImgUrlArray = [NSMutableArray array];
                for (int i =0; i < _homeFocusArray.count; i++) {
                    DataListModel *dataListModel = _homeFocusArray[i];
                    [_homeFocusImgUrlArray addObject:dataListModel.imagUrl];
                }
                // 刷新表格
                [self.tableView reloadData];
                
            }else {
                //                [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            }
        }
        return YES;
    }];
}

#pragma mark - 请求数据 优惠推荐
/// 优惠推荐
- (void)getDiscountData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1060" forKey:@"rec_code"];
    [dictParam setValue:@"1" forKey:@"rec_type"]; // 1 汽车 2 摩托车
    [dictParam setValue:@"1" forKey:@"rec_key"]; // 1获取首页列表 2 获取更多列表
    [dictParam setValue:@"1" forKey:@"rec_pageIndex"];  // 第几页 默认1
    [dictParam setValue:@"10" forKey:@"rec_pageSize"];  // 每页多少条
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    NSLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@", result);
        if (error) {
            if (self.requestCountMark < requestCountLimit) {
                self.requestCountMark++;
                [self getDiscountData];
                return NO;
            } else {
                [self hidenLoadingView];
            }
        } else {
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                _pageIndex = 1;
                _homeDiscountModels = [HomeDiscountModels mj_objectWithKeyValues:result];
                _brandArray = [NSMutableArray arrayWithArray:_homeDiscountModels.dataList];
                // 刷新表格
                [self.tableView reloadData];
                
            }else {
                //                [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            }
        }
        return YES;
    }];
}


#pragma mark - UITableViewDelegate
///  返回多少组数据
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

// 第section分区一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0 || section == 1 || section == 2) {
        return 1;
    }else if(section == 3){
        //        return 1 + _brandArray.count;
        return self.brandArray.count > 3 ? 4 : 1 + self.brandArray.count;//优惠推荐最多显示3条随机的数据
    }
    return 1;
}

// 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return kUIScreenHeight * HomeHeadheight;  // 210
    } else if (indexPath.section == 1) {
        
        CGFloat homeCellHeight;
        if (IS_IPHONE4) {
            homeCellHeight = HomeMenuCellHeight;
        } else if (IS_IPHONE5) {
            homeCellHeight = HomeMenuCellHeight;
        }else if (IS_IPHONE6) {
            homeCellHeight = HomeMenuCellHeight + 5;
        }else if (IS_IPHONE6_PLUS) {
            homeCellHeight = HomeMenuCellHeight + 10;
        }else {
            homeCellHeight = HomeMenuCellHeight;
        }
        
        return homeCellHeight;
    }else if (indexPath.section == 2) {
        return kUIScreenHeight * HomeCellHeight;
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 45.0;
        }
        return 130;
    }
    return 0;
}

#pragma mark - UITableViewCell
// 返回cell 视图
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey";
    //首先根据标示去缓存池取
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //如果缓存池没有取到则重新创建并放到缓存池中
    if(cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    };
    
    if (indexPath.section == 0) {// 图片
        ImageMallViewCell *cell = [ImageMallViewCell cellWithTableView:tableView];
        cell.model = self.topImageModel;
        return cell;
    }else if (indexPath.section == 1) {
        // 菜单功能块集合
        GroupTableViewCell *cell = [[GroupTableViewCell alloc] init];
        
        cell.collArray = self.collArray;
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.section == 2){
        // 加载无限轮播器
        //        return self.adsCell;
        AdsTableCell *cell = [AdsTableCell cellWithTableView:tableView];
        cell.imgArray = _homeFocusImgUrlArray;
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {  // 优惠头部
            HomeTitleCell *cell = [HomeTitleCell cellWithTableView:tableView];
            return cell;
        }else {  // 优惠推荐
            //优惠推荐只显示3条随机的数据
            HomeDiscountCell *cell = [HomeDiscountCell cellWithTableView:tableView];
            cell.model =  _brandArray[indexPath.row -1];
            return cell;
        }
    }
    
    return cell;
}

// 设置分组标题内容高度  cell Footer 高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 3) {
        return 0.000000001;
    }
    
    return 12.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 12)];
    view.backgroundColor = [UIColor colorWithRed:0.953  green:0.957  blue:0.961 alpha:1];
    return view;
}


#pragma mark - UITableView Delegate
// 选中cell时触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Cell 选中效果取消
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 2) {
        
        //        NSString *urlStr =  [[GetUrlString sharedManager] urlWithMallWebData];
        //        DefaultWebController *mallVC = [[DefaultWebController alloc]init];
        //        mallVC.urlStr = urlStr;
        //        [self.navigationController pushViewController:mallVC animated:YES];
        
    }else if (indexPath.section ==3) {
        
        if (indexPath.row == 0) {
            
            DefaultWebController *menuWebVC = [[DefaultWebController alloc]init];
            NSString *urlStr =  [[GetUrlString sharedManager] urlBrandAct];
            menuWebVC.urlStr = [YHFunction getWebUrlWithUrl:urlStr];
            menuWebVC.title = @"优惠活动";
            menuWebVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:menuWebVC animated:YES];
            
        } else {
            // 跳转到优惠活动 - 详情
            HomeDiscountModel *model = _brandArray[indexPath.row -1];
            DefaultWebController *vc = [[DefaultWebController alloc]init];
            NSString *urlStr =  model.detailUrl;
            vc.urlStr = [YHFunction getWebUrlWithUrl:urlStr];
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }
}



#pragma mark - 图片轮播器回调
// 图片轮播器回调方法
- (void)didAdsSelectItemAtIndex:(NSInteger)index {
    NSLog(@"---首页轮播被点击了第%ld张图片", (long)index);
    
}





#pragma mark - 主页功能菜单跳转
- (void)didMenuSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YHLog(@"点击菜单===%zd",indexPath.row);
    NSString *urlStr = nil;
    DefaultWebController *menuWebVC = [[DefaultWebController alloc]init];
    if (indexPath.row == 0) { // 优惠活动
        
        urlStr =  [[GetUrlString sharedManager] urlBrandAct];
        menuWebVC.urlStr = [YHFunction getWebUrlWithUrl:urlStr];
        menuWebVC.title = @"优惠活动";
        menuWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:menuWebVC animated:YES];
        
    } else if(indexPath.row == 1){  // 二手车
        UsedCarController *vc = [[UsedCarController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;  // 隐藏tabbar
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 2){  // 智能车联
        //智能车联
        //http://www.yholink.com:8087/shop/happ/car_joint.html
        urlStr =  [[GetUrlString sharedManager] urlCarGroup];
        menuWebVC.urlStr =  [YHFunction getWebUrlWithUrl:urlStr];
        menuWebVC.hidesBottomBarWhenPushed = YES;
        
        UIButton *rightBackBtn = [[UIButton alloc] init];
        rightBackBtn.frame = CGRectMake(0, 0, 44, 44);
        rightBackBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        rightBackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightBackBtn setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
        [rightBackBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        menuWebVC.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBackBtn];
        
        [self.navigationController pushViewController:menuWebVC animated:YES];
        
    }else if(indexPath.row == 3){  // 团购
        
        [self showHint:@"此功能还未开放，敬请期待。"];
        
        //        urlStr =  [[GetUrlString sharedManager]urlBuyCarWeb];
        //        menuWebVC.urlStr = urlStr;
        //        [self.navigationController pushViewController:menuWebVC animated:YES];
        
    }else if(indexPath.row == 5){
        urlStr =  [[GetUrlString sharedManager] urlBoutiqueWeb];
        menuWebVC.urlStr = urlStr;
        [self.navigationController pushViewController:menuWebVC animated:YES];
    }
}

#pragma 智能车联分享
- (void)shareBtnClick:(UIButton *)btn {
    CarJointShareController *shareVC = [[CarJointShareController alloc] init];
    
    shareVC.path = [NSString stringWithFormat:@"%@?uid=%zd",[[GetUrlString sharedManager] urlCarGroupShare],[YHUserInfo shareInstance].uId];
    
    [shareVC show];
    
}


#pragma mark 去掉UItableview headerview黏性(sticky)
//去掉UItableview headerview黏性(sticky)
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat sectionHeaderHeight = 12;//设置你footer高度
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


#pragma mark --UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
//    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    self.title = theTitle;
//    [_activityView stopAnimating];
    
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
    
    if([urlComps count] && [urlComps[0]rangeOfString:@"objc"].location !=NSNotFound)
    {
        //  objc://getParam1:withParam2:$|我来自ios苹果$|我来自earth地球
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@"$|"];  // 本地测试用  :/
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        
        if (1 == [arrFucnameAndParameter count])
        {
            // 没有参数
            if([funcStr isEqualToString:@"showHeader"])
            {
                [self showHeader];

                
            }
            // 没有参数
            if([funcStr isEqualToString:@"hideHeader"])
            {
                
                [self hideHeader];

                
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
        return YES;
    }
    
//    [_activityView startAnimating];
    return YES;
}


- (void)hideHeader{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    self.view.frame = CGRectMake(0, 20, kUIScreenWidth, kUIScreenHeight - 20);
    
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

- (void)showHeader{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
    self.view.frame = CGRectMake(0, kUINavHeight, kUIScreenWidth, kUIScreenHeight - kUINavHeight);
    
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-49);
    }];

}




//#pragma mark UITableView + 上拉刷新 加载更多
//- (void)footerRefresh
//{
//    // 添加默认的上拉刷新
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//
//    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsedData)];
//
//    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
//    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStatePulling];
//    [refreshFooter setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
//    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateWillRefresh];
//    [refreshFooter setTitle:@"已显示全部内容" forState:MJRefreshStateNoMoreData];
//
//    self.tableView.mj_footer = refreshFooter;
//}



//#pragma mark - 上拉加载更多数据 分页
//- (void)loadMoreUsedData {
//
//    if (self.brandArray.count < self.homeDiscountModels.res_pageTotalSize) {
//        self.pageIndex++;
//    }else{
//        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        return;
//    }
//
//    // 创建一个空字典
//    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
//    [dictParam setValue:@"1060" forKey:@"rec_code"];
//
//    [dictParam setValue:@"1" forKey:@"rec_type"]; // 1摩托车2汽车
//    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.pageIndex] forKey:@"rec_pageIndex"]; // 第几页,默认值1a
//    [dictParam setValue:@"10" forKey:@"rec_pageSize"];  // 每页多少条
//
//    //  MD5 加密
//    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
//
//    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
//
//        //        YHLog(@"%@",result);
//        if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
//
//            _homeDiscountModels = [HomeDiscountModels mj_objectWithKeyValues:result];
//            [_brandArray addObjectsFromArray:_homeDiscountModels.dataList];
//            // 刷新表格
//            [self.tableView reloadData];
//            // 拿到当前的上拉刷新控件，结束刷新状态
//            [self.tableView.mj_footer endRefreshing];
//        }else{
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
//        return YES;
//    }];
//}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
