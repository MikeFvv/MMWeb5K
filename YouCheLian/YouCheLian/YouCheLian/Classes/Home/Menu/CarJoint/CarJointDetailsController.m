//
//  CarJointDetailsController.m
//  YouCheLian
//
//  Created by Mike on 16/3/4.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "CarJointDetailsController.h"
#import <MJExtension.h>
#import "CarDetailsModel.h"
#import "DetailsPhotoModels.h"
#import "DetailsPhotoModel.h"
#import "BuyCarViewController.h"

#import "CarDetailsHeadView.h"

#import "CarShopDetailsModel.h"
#import "CarCommentModels.h"
#import "CarCommentModel.h"

#import "CarJointIntroduceCellTableViewCell.h"
#import "GoodsServiceCell.h"
#import "GoodsColorCell.h"
#import "CarCommentCell.h"
#import "CarShopInfoCell.h"

#import "CarDetailsSubViewController.h"
#import "ShopDetailsTableController.h"

#import "ShopDetailsModel.h"
#import "ServiceListModel.h"
#import "CarColorListModel.h"

#import "DefaultWebController.h"
#import "CarDetailsHeadCollectionViewCell.h"

#import "ZLPhoto.h"
#import "CommentCollectionViewCell.h"

#import "LoginViewController.h"
#import "YHNavigationController.h"

#import "FoundShareViewController.h"

// 最大请求次数
#define requestCountLimit 4

@interface CarJointDetailsController ()<UITableViewDataSource,UITableViewDelegate,BuyCarViewControllerDelegate,CarDetailsSubViewControllerDelegate,UIScrollViewDelegate,CarDetailsHeadViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,CarCommentCellDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) DetailsPhotoModels *detailsPhotoModels;
@property (nonatomic, strong) DetailsPhotoModel *detailsPhotoModel;
@property (nonatomic, strong) NSMutableArray *photoMArray;

@property (nonatomic, strong) CarDetailsModel *carDetailsModel;
@property (nonatomic, strong) NSArray *carArray;


@property (nonatomic, strong) CarShopDetailsModel *carShopDetailsModel;
@property (nonatomic, strong) CarCommentModels *carCommentModels;
@property (nonatomic, strong) CarCommentModel *carCommentModel;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) ShopDetailsModel *shopDetailsModel;


///选择颜色的下标
@property (nonatomic, assign) NSInteger colorSelectIndex ;

@property (nonatomic, assign) int buyCount;


@property (nonatomic, assign) BOOL isCollectState;
@property (nonatomic, strong) UIImageView *imagCollView;  // 收藏

@property (nonatomic, strong) NSArray *imageUrlArray;

//颜色分类选择信息
@property (nonatomic, copy) NSString *selectInfo;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CarDetailsSubViewController *carDetailsSubVC;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) CarDetailsHeadView *carDetailsHeadView;
@property (nonatomic, strong, nullable)UICollectionView *currentView; //
@property (nonatomic, strong, nullable)NSArray *currentArray; //

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, assign) NSInteger requestCountMark;

@property (nonatomic, assign) NSInteger delegateMark;
@property (nonatomic, strong) NSArray *commentImagArray;
@property (nonatomic, strong) NSArray *commentImagArray1;
@property (nonatomic, strong) NSArray *commentImagArray2;

@end

@implementation CarJointDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initScrollView];
    [self initView];
    [self initTableView];
    _requestCountMark = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectionViewNoImageCell" bundle:nil] forCellReuseIdentifier:@"CollectionViewNoImageCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CarCommentCell" bundle:nil] forCellReuseIdentifier:@"CarCommentCell"];
    
    [self setCarouselImage];
    
    [self dispatchGroup];
    
    //    [self setCarouselImage];
    //    [self getCarDetailsData];
    [self.view bringSubviewToFront:_headView];
    //
    //    [self getCommentData];
    //    [self getGoodsDetailsData];
    
    //    [self footerRefresh];
    [self setRefreshHeaderFooter];
    //设置选择颜色分类
    self.selectInfo = @"请选择颜色分类";
    //设置初始购买数量
    self.buyCount = 1;
    
}

///  调度组
- (void)dispatchGroup {
    //  群组－统一监控一组任务
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    
    [self showLoadingView];
    // 添加任务
    // group 负责监控任务，queue 负责调度任务
    dispatch_group_async(group, q, ^{
        [NSThread sleepForTimeInterval:1.0];
        
        // 加载数据
        [self getCycleScrollData];
        NSLog(@"任务1 %@", [NSThread currentThread]);
    });
    dispatch_group_async(group, q, ^{
        [self getCarDetailsData];
        NSLog(@"任务2 %@", [NSThread currentThread]);
    });
    //    dispatch_group_async(group, q, ^{
    //        [self getCommentData];
    //        NSLog(@"任务3 %@", [NSThread currentThread]);
    //    });
    
    
    
    
    // 监听所有任务完成 － 等到 group 中的所有任务执行完毕后，"由队列调度 block 中的任务异步执行！"
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 修改为主队列，后台批量下载，结束后，主线程统一更新UI
        self.scrollView.hidden = NO;
        
        [self hidenLoadingView];
        NSLog(@"任务OK %@", [NSThread currentThread]);
    });
    
    NSLog(@"come here");
}

- (void)viewWillAppear:(BOOL)animated {
    //    // 设置导航栏颜色 字体颜色 及大小
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    // 隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}


#pragma mark - 视图初始化
- (void)initScrollView {
    // 自动调整 ScrollView 缩进 <不在状态栏下面>
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight)];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.hidden = YES;
    //    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(kUIScreenWidth, kUIScreenHeight * 2);
    //    self.scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.scrollView];
    
    
    _carDetailsSubVC = [[CarDetailsSubViewController alloc] init];
    _carDetailsSubVC.carId = self.carId;
    _carDetailsSubVC.type = self.type;
    _carDetailsSubVC.delegate = self;
    _carDetailsSubVC.view.frame = CGRectMake(0, kUIScreenHeight, kUIScreenWidth, kUIScreenHeight);
    [self.scrollView addSubview:_carDetailsSubVC.view];
}

-(void)initView {
    
    
    [self setupHeadView];
    
    
    // ============= 底部视图 =============
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    _bottomView= bottomView;
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(@49);
    }];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor colorWithRed:0.882  green:0.878  blue:0.882 alpha:1];
    [bottomView addSubview:topLine];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left);
        make.right.equalTo(bottomView.mas_right);
        make.top.equalTo(bottomView.mas_top);
        make.height.mas_equalTo(@1);
    }];
    
    // 立即购买
    UIButton *buyBtn = [[UIButton alloc] init];
    
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [buyBtn setBackgroundColor:[UIColor redColor]];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:buyBtn];
    
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.right.equalTo(bottomView.mas_right);
        make.bottom.equalTo(bottomView.mas_bottom);
        make.width.mas_equalTo(kUIScreenWidth * 0.4);
    }];
    
    // 电话咨询
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor whiteColor];
    
    //给view添加点击手势
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewClickAction:)];
    [view1 addGestureRecognizer:tap1];
    view1.tag = 1;
    
    [bottomView addSubview:view1];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left);
        make.top.equalTo(topLine.mas_bottom);
        make.bottom.equalTo(bottomView.mas_bottom);
        make.width.mas_equalTo((kUIScreenWidth - (kUIScreenWidth * 0.4))/3);
    }];
    
    
    
    UIImageView *imagView1 = [[UIImageView alloc] init];
    imagView1.image = [UIImage imageNamed:@"rec_phone"];
    [view1 addSubview:imagView1];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"电话";
    label1.font = YHFont(12, NO);;
    label1.textColor = [UIColor darkGrayColor];
    [view1 addSubview:label1];
    
    [imagView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view1.mas_centerX);
        make.bottom.equalTo(label1.mas_top).with.offset(-1);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view1.mas_centerX);
        make.bottom.equalTo(view1.mas_bottom).with.offset(-5);
    }];
    
    
    // 收藏
    UIView *view3 = [[UIView alloc] init];
    view3.backgroundColor = [UIColor whiteColor];
    //给view添加点击手势
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewClickAction:)];
    [view3 addGestureRecognizer:tap3];
    view3.tag = 3;
    [bottomView addSubview:view3];
    
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1.mas_right);
        make.top.equalTo(topLine.mas_bottom);
        make.bottom.equalTo(bottomView.mas_bottom);
        //        make.width.mas_equalTo((kUIScreenWidth-(kUIScreenWidth * 0.28))/3);
        make.width.mas_equalTo(view1.mas_width);
    }];
    
    
    
    _imagCollView = [[UIImageView alloc] init];
    
    _imagCollView.image = [UIImage imageNamed:@"rec_collection"];
    
    [view3 addSubview:_imagCollView];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"收 藏";
    label3.font = YHFont(12, NO);;
    label3.textColor = [UIColor darkGrayColor];
    [view3 addSubview:label3];
    
    [_imagCollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view3.mas_centerX);
        make.bottom.equalTo(label3.mas_top).with.offset(-1);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view3.mas_centerX);
        make.bottom.equalTo(view3.mas_bottom).with.offset(-5);
    }];
    
    // 购物车
    UIView *view4 = [[UIView alloc] init];
    view4.backgroundColor = [UIColor whiteColor];
    //给view添加点击手势
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewClickAction:)];
    [view4 addGestureRecognizer:tap4];
    view4.tag = 4;
    [bottomView addSubview:view4];
    
    [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view3.mas_right);
        make.top.equalTo(topLine.mas_bottom);
        make.bottom.equalTo(bottomView.mas_bottom);
        //        make.width.mas_equalTo((kUIScreenWidth-(kUIScreenWidth * 0.28))/3);
        make.width.mas_equalTo(view1.mas_width);
    }];
    
    
    UIImageView *imagView4 = [[UIImageView alloc] init];
    imagView4.image = [UIImage imageNamed:@"rec_shoppingcart"];
    [view4 addSubview:imagView4];
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.text = @"购物车";
    label4.font = YHFont(12, NO);;
    label4.textColor = [UIColor darkGrayColor];
    [view4 addSubview:label4];
    
    [imagView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view4.mas_centerX);
        make.bottom.equalTo(label4.mas_top).with.offset(-1);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view4.mas_centerX);
        make.bottom.equalTo(view4.mas_bottom).with.offset(-5);
    }];
    
}

#pragma mark - 头部导航栏
- (void)setupHeadView {
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 64)];
    _headView.backgroundColor = [UIColor clearColor];
    
    UIView *colorView = [[UIView alloc] initWithFrame:_headView.frame];
    colorView.backgroundColor = [UIColor colorWithRed:0.973  green:0.976  blue:0.980 alpha:1];
    colorView.alpha = 0;
    colorView.tag = 100;
    
    [self.headView addSubview: colorView];
    [self.view addSubview:_headView];
    
    //按钮背景1
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"nav_back_2bg"];
    bgImageView.alpha = 1;
    bgImageView.tag = 102;
    [_headView addSubview:bgImageView];
    
    //后退按钮
    UIButton *leftBackBtn = [[UIButton alloc] init];
    [leftBackBtn addTarget:self action:@selector(onBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [leftBackBtn setImage:[UIImage imageNamed:@"nav_back_2"] forState:UIControlStateNormal];
    [_headView addSubview:leftBackBtn];
    
    [leftBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headView.mas_centerY).with.offset(8);
        make.left.equalTo(_headView.mas_left).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftBackBtn.mas_centerY);
        make.left.equalTo(leftBackBtn.mas_left);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    
    //按钮背景2
    UIImageView *bgImageView2 = [[UIImageView alloc] init];
    bgImageView2.image = [UIImage imageNamed:@"nav_share_bg"];
    bgImageView2.alpha = 1;
    bgImageView2.tag = 103;
    bgImageView2.hidden = YES;//暂时隐藏
    
    [_headView addSubview:bgImageView2];
    
    
    //分享按钮
    UIButton *rightBackBtn = [[UIButton alloc] init];
    //    rightBackBtn.tag = 104;
    [rightBackBtn setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    [rightBackBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBackBtn.hidden = YES;//暂时隐藏
    [_headView addSubview:rightBackBtn];
    
    [rightBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftBackBtn.mas_centerY);
        make.right.equalTo(_headView.mas_right).with.offset(-8);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    [bgImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rightBackBtn.mas_centerY);
        make.left.equalTo(rightBackBtn.mas_left);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    
    //中间标题
    UILabel *midLabel = [[UILabel alloc] init];
    midLabel.tag = 101;
    midLabel.text = @"商品详情";
    midLabel.font = [UIFont systemFontOfSize:18];
    midLabel.textColor = [UIColor blackColor];
    midLabel.alpha = 0;
    [_headView addSubview:midLabel];
    
    [midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftBackBtn.mas_centerY);
        make.centerX.equalTo(_headView.mas_centerX);
        
    }];
    
    //分隔线
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0;
    line.tag = 104;
    [_headView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_headView.mas_bottom);
        make.left.mas_equalTo(_headView.mas_left);
        make.right.mas_equalTo(_headView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    
}

///  分享按钮点击
-(void)shareBtnClick:(id)sender {
    
    FoundShareViewController *shareVC = [[FoundShareViewController alloc] init];
    //要分享的链接
    //    shareVC.path = [NSString stringWithFormat:@"%@?type=2&accid=%@&phone=%@",self.footBookDataListModel.res_path,self.accId.stringValue,[YHUserInfo shareInstance].uPhone];
    
    shareVC.path = @"http://www.baidu.com";
    
    [shareVC show];
    
    
}

-(void)onBackBtn:(UIButton *)sender {
    // 在push控制器时显示UITabBar
    self.hidesBottomBarWhenPushed = NO;
    // 将栈顶的控制器移除
    [self.navigationController popViewControllerAnimated:YES];
}
///  返回首页
-(void)onBackHome:(id)sender {
    // 在push控制器时显示UITabBar
    self.hidesBottomBarWhenPushed = NO;
    // 将栈顶的控制器移除
    [self.navigationController popToViewController:(UIViewController *)self.navigationController.viewControllers[1] animated:YES];
}

-(void)initTableView {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView =[UITableView initWithTableView:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight - kUITabBarHeight ) withDelegate:self];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scrollView addSubview:self.tableView];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    YHLog(@"%f",scrollView.contentOffset.y);
    UIView *colorView = [self.headView viewWithTag:100];
    colorView.alpha = scrollView.contentOffset.y / 100;
    
    UILabel *label = [self.headView viewWithTag:101];
    label.alpha = colorView.alpha;
    
    UIImageView *bgImageView = [self.headView viewWithTag:102];
    bgImageView.alpha = 1 - colorView.alpha;
    
    UIImageView *bgImageView2 = [self.headView viewWithTag:103];
    bgImageView2.alpha = 1 - colorView.alpha;
    
    UIView *line = [self.headView viewWithTag:104];
    line.alpha = 0.3 * colorView.alpha;
}




#pragma mark - 3个子控制器的下拉刷新代理
- (void)carDetailsSubDownRefresh {
    _bottomView.hidden = NO;
    
    UIView *colorView = [self.headView viewWithTag:100];
    colorView.alpha = self.tableView.contentOffset.y / 100;
    
    UILabel *label = [self.headView viewWithTag:101];
    label.alpha = colorView.alpha;
    
    UIImageView *bgImageView = [self.headView viewWithTag:102];
    bgImageView.alpha = 1 - colorView.alpha;
    
    UIImageView *bgImageView2 = [self.headView viewWithTag:103];
    bgImageView2.alpha = 1 - colorView.alpha;
    
    UIView *line = [self.headView viewWithTag:104];
    line.alpha = 0.3 * colorView.alpha;
    
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, kUIScreenWidth, self.view.frame.size.height) animated:YES];
}


#pragma mark - 设置上拉下拉
- (void)setRefreshHeaderFooter
{
    //    __weak typeof(self) weakSelf = self;
    // 添加默认的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upScrollLoad)];
    
    [refreshFooter setTitle:@"上拉加载图文详情" forState:MJRefreshStateIdle];
    [refreshFooter setTitle:@"上拉加载图文详情" forState:MJRefreshStatePulling];
    [refreshFooter setTitle:@"上拉加载图文详情" forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"上拉加载图文详情" forState:MJRefreshStateWillRefresh];
    [refreshFooter setTitle:@"上拉加载图文详情" forState:MJRefreshStateNoMoreData];
    
    self.tableView.mj_footer = refreshFooter;
}

#pragma mark UITableView + 上拉刷新 自定义文字
- (void)footerRefresh
{
    // 添加默认的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upScrollLoad)];
    
    // 设置文字
    [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"加载完毕了" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    // 设置颜色
    footer.stateLabel.textColor = [UIColor blueColor];
    // 设置footer
    self.tableView.mj_footer = footer;
}
#pragma mark 上拉加载更多数据
- (void)upScrollLoad
{
    //    __weak typeof(self) weakSelf = self;
    [self.tableView.mj_footer endRefreshing];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.scrollView scrollRectToVisible:CGRectMake(0, self.view.frame.size.height, kUIScreenWidth, self.view.frame.size.height) animated:YES];
        _bottomView.hidden = YES;
        
        UIView *colorView = [self.headView viewWithTag:100];
        colorView.alpha = 1;
        
        UILabel *label = [self.headView viewWithTag:101];
        label.alpha = colorView.alpha;
        
        UIImageView *bgImageView = [self.headView viewWithTag:102];
        bgImageView.alpha = 1 - colorView.alpha;
        
        UIImageView *bgImageView2 = [self.headView viewWithTag:103];
        bgImageView2.alpha = 1 - colorView.alpha;
        
        UIView *line = [self.headView viewWithTag:104];
        line.alpha = 0.3 * colorView.alpha;
        
        
        [self.carDetailsSubVC.segment selectIndex:1];
        [self.carDetailsSubVC.flipView selectIndex:0];
        
    });
    //    [self.tableView.footer endRefreshing];
}

#pragma mark - Table Header图片设置
- (void)setCarouselImage {
    
    _carDetailsHeadView = [[CarDetailsHeadView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenWidth / 375 * 350)];
    _carDetailsHeadView.delegate = self;
    
    [self.tableView setTableHeaderView:_carDetailsHeadView];
    
}


#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section {
    
    if (self.delegateMark == 0) {
        return [self.photoMArray count];
    } else if(self.delegateMark == 1) {
        // 分割 截取字符串  如果没有图片=0
        self.commentImagArray1 = [_carCommentModel.imageUrls componentsSeparatedByString:@","];
        return [self.commentImagArray1 count];
    } else {
        return [self.commentImagArray2 count];
    }
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegateMark == 0) {  // header 头部
        id imageObj = [self.photoMArray objectAtIndex:indexPath.item];
        ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
        // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
        CarDetailsHeadCollectionViewCell *cell = (CarDetailsHeadCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        // 缩略图
        if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
            photo.asset = imageObj;
        }
        photo.toView = cell.imagView;
        photo.thumbImage = cell.imagView.image;
        return photo;
    } else if(self.delegateMark == 1) { // 1条评价详情页面
        id imageObj = [self.commentImagArray1 objectAtIndex:indexPath.item];
        ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
        // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
        CommentCollectionViewCell *cell = (CommentCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        // 缩略图
        if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
            photo.asset = imageObj;
        }
        photo.toView = cell.imagView;
        photo.thumbImage = cell.imagView.image;
        return photo;
    }else {  // 全部评价页面
        id imageObj = [self.commentImagArray2 objectAtIndex:indexPath.item];
        ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
        // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
        CarDetailsHeadCollectionViewCell *cell = (CarDetailsHeadCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        // 缩略图
        if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
            photo.asset = imageObj;
        }
        photo.toView = cell.imagView;
        photo.thumbImage = cell.imagView.image;
        return photo;
    }
    
}




#pragma mark 获取首页广告数据
// 解析数据获取轮播图片内容
- (void)getCycleScrollData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1058" forKey:@"rec_code"];
    [dictParam setValue:self.carId forKey:@"rec_id"];  // 商品Id
    [dictParam setValue:self.type forKey:@"rec_type"];  //1=新车，2=活动车
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@",result);
        if (error) {
            if (self.requestCountMark < requestCountLimit) {
                self.requestCountMark++;
                [self getCycleScrollData];
            }else {
                [self hidenLoadingView];
                [self showMessage:@"网络请求错误" delay:1];
            }
        } else {
            
            _photoMArray = [NSMutableArray array];
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                _detailsPhotoModels = [DetailsPhotoModels mj_objectWithKeyValues:result];
                
                // 获取图片url
                for (int i =0; i < _detailsPhotoModels.dataList.count; i++) {
                    _detailsPhotoModel = _detailsPhotoModels.dataList[i];
                    [_photoMArray addObject:_detailsPhotoModel.imgUrl];
                }
                [_carDetailsHeadView setArrayImageUrl: _photoMArray];
                
                [self.tableView reloadData];
            } else {
                [_carDetailsHeadView setArrayImageUrl: _photoMArray];
            }
        }
        return YES;
    }];
}


#pragma mark - 获取商品详情数据
/// 获取商品详情数据
- (void)getCarDetailsData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1065" forKey:@"rec_code"];
    
    [dictParam setValue:[YHUserInfo shareInstance].isLogin ?[YHUserInfo shareInstance].uPhone : @"0" forKey:@"rec_userPhone"];
    
    [dictParam setValue:self.carId forKey:@"rec_id"]; // 新车ID
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if (error) {
            if (self.requestCountMark < requestCountLimit) {
                self.requestCountMark++;
                [self getCarDetailsData];
            }else {
                [self hidenLoadingView];
                [self showMessage:@"网络请求错误" delay:1];
            }
        }else {
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                _carDetailsModel = [CarDetailsModel mj_objectWithKeyValues:result];
                
                _carDetailsSubVC.spec = _carDetailsModel.spec;
                _carDetailsSubVC.desc = _carDetailsModel.desc;
                if (_carDetailsModel.isCollection == 0) { // 未收藏
                    _isCollectState = NO;
                    _imagCollView.image = [UIImage imageNamed:@"rec_collection"];
                } else {  // 已收藏
                    _isCollectState = YES;
                    _imagCollView.image = [UIImage imageNamed:@"rec_collection_press"];;
                }
                
                
                // 刷新表格
                [self.tableView reloadData];
                // 拿到当前的上拉刷新控件，结束刷新状态
                // [self.tableView.mj_footer endRefreshing];
            }else {
                _isCollectState = NO;
                _imagCollView.image = [UIImage imageNamed:@"rec_collection"];
                
                [self hidenLoadingView];
                [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            }
        }
        return YES;
    }];
}

#pragma mark - 获取评价数据
/// 获取评价数据
//- (void)getCommentData {
//    // 创建一个空字典
//    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
//    [dictParam setValue:@"1061" forKey:@"rec_code"];
//    [dictParam setValue:self.carId forKey:@"rec_id"]; // 商品ID
//    [dictParam setValue:@"0" forKey:@"rec_type"]; //0=全部评价，1=好评，2=中评，3=差评，4=有图
//    [dictParam setValue:self.type forKey:@"rec_kind"]; // 0=商城,1=新车，2=活动车
//    [dictParam setValue:@"1" forKey:@"rec_pageIndex"]; // 第几页,默认值1
//    [dictParam setValue:@"10" forKey:@"rec_pageSize"]; //每页多少条，默认值5
//    //  MD5 加密
//    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
//
//
//    YHLog(@"%@",dictParam);
//
//    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
//
//        YHLog(@"%@",result);
//        if (error) {
//            if (self.requestCountMark < requestCountLimit) {
//                self.requestCountMark++;
//                [self getCommentData];
//            }else {
//                [self hidenLoadingView];
//                [self showMessage:@"网络请求错误" delay:1];
//            }
//        }else {
//            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
//                _carCommentModels = [CarCommentModels mj_objectWithKeyValues:result];
//
//                if (_carCommentModels.dataList.count > 0) {
//                    _carCommentModel = _carCommentModels.dataList[0];
//                }
//
//                // 分割 截取字符串  如果没有图片=0
//                self.imageUrlArray = [_carCommentModel.imageUrls componentsSeparatedByString:@","];
//                // 刷新表格
//                [self.tableView reloadData];
//                // 拿到当前的上拉刷新控件，结束刷新状态
//                // [self.tableView.mj_footer endRefreshing];
//            }else {
//                [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
//            }
//        }
//        return YES;
//    }];
//}
// 详情页 head 幻灯片
- (void)carDetailsHeadViewCell:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.delegateMark = 0;
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    
    // 数据源/delegate
    // 动画方式
    /*
     *
     UIViewAnimationAnimationStatusZoom = 0,  放大缩小
     UIViewAnimationAnimationStatusFade , // 淡入淡出
     UIViewAnimationAnimationStatusRotate // 旋转
     pickerBrowser.status = UIViewAnimationAnimationStatusFade;
     */
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    
    self.collectionView = collectionView;
    // 是否可以删除照片
    pickerBrowser.editing = NO;
    // 当前分页的值
    // pickerBrowser.currentPage = indexPath.row;
    // 传入组
    pickerBrowser.currentIndexPath = indexPath;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}

#pragma mark - 评价图片点击代理回调
- (void)carCommentCellCell:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imagArray:(NSArray *)imagArray {
    
    self.delegateMark = 1;
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    
    self.commentImagArray1 = imagArray;
    // 数据源/delegate
    // 动画方式
    /*
     *
     UIViewAnimationAnimationStatusZoom = 0, // 放大缩小
     UIViewAnimationAnimationStatusFade , // 淡入淡出
     UIViewAnimationAnimationStatusRotate // 旋转
     pickerBrowser.status = UIViewAnimationAnimationStatusFade;
     */
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    
    self.collectionView = collectionView;
    // 是否可以删除照片
    pickerBrowser.editing = NO;
    // 当前分页的值
    // pickerBrowser.currentPage = indexPath.row;
    // 传入组
    pickerBrowser.currentIndexPath = indexPath;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}


- (void)carEvaluationCellCell:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imagArray:(NSArray *)imagArray {
    
    self.delegateMark = 3;
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    
    // 分割 截取字符串  如果没有图片=0
    //    CarCommentModel *model = imagArray[indexPath.row];
    //    self.commentImagArray2 = [model.imageUrls componentsSeparatedByString:@","];
    
    self.commentImagArray2 = imagArray;
    // 数据源/delegate
    // 动画方式
    /*
     *
     UIViewAnimationAnimationStatusZoom = 0, // 放大缩小
     UIViewAnimationAnimationStatusFade , // 淡入淡出
     UIViewAnimationAnimationStatusRotate // 旋转
     pickerBrowser.status = UIViewAnimationAnimationStatusFade;
     */
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    self.collectionView = collectionView;
    // 是否可以删除照片
    pickerBrowser.editing = NO;
    // 当前分页的值
    // pickerBrowser.currentPage = indexPath.row;
    // 传入组
    pickerBrowser.currentIndexPath = indexPath;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}




#pragma mark - UITableView 代理数据源方法
/// 返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
}


// 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        if (_carDetailsModel.cellHeight == 0 || _carDetailsModel == nil) {
            return 85.f;
        }
        return _carDetailsModel.cellHeight;
        
    } else if (indexPath.row == 1){// 商品服务保证
        
        return self.carDetailsModel.serviceList.count < 4 ? 40 : 60;
        
    }else if (indexPath.row == 2){
        return 10;
    }else if (indexPath.row == 3){
        return 40;
    }else if (indexPath.row == 4){
        return 10;
    }
    //    else if (indexPath.row == 5){  // 评价头部
    //        return 40;
    //    }else if (indexPath.row == 6){  // 评价
    //
    //        if (_carCommentModel.cellHeight == 0 || _carCommentModel == nil) {
    //            return 0;
    //        }
    //        return _carCommentModel.cellHeight;
    //
    //    }
    else if (indexPath.row == 5){
        return 10;
    }
    //        else if (indexPath.row == 8){
    //        return 130;
    //    }
    return 44;
}

#pragma mark - UITableViewCell
// 返回cell 视图
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey";
    // 首先根据标示去缓存池取
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // 如果缓存池没有取到则重新创建并放到缓存池中
    if(cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    };
    
    if (indexPath.row == 0) {  // 商品简介
        CarJointIntroduceCellTableViewCell *cell = [CarJointIntroduceCellTableViewCell cellWithTableView:tableView];
        cell.model = _carDetailsModel;
        return cell;
    } else if (indexPath.row == 1) {  // 商品服务保证
        GoodsServiceCell *cell = [GoodsServiceCell cellWithTableView:tableView];
        cell.dataModels = self.carDetailsModel.serviceList;
        return cell;
    }else if (indexPath.row == 2) {  // Line
        cell.backgroundColor = [UIColor colorWithRed:0.918  green:0.918  blue:0.918 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 3) { // 颜色分类
        GoodsColorCell *cell = [GoodsColorCell cellWithTableView:tableView];
        cell.selectInfo = self.selectInfo;
        return cell;
    }else if (indexPath.row == 4) {  // Line
        cell.backgroundColor = [UIColor colorWithRed:0.918  green:0.918  blue:0.918 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    //    else if (indexPath.row == 5) {  // 评价头
    //        CarCommentHeadCell *cell = [CarCommentHeadCell cellWithTableView:tableView];
    //        cell.model = _carCommentModels;
    //        return cell;
    //    }else if (indexPath.row == 6) {  // 评价
    //
    //        if (_carCommentModel == nil) {
    //            return cell;
    //        }
    //
    //        if (_carCommentModel.imageUrls.length > 0) {
    //            CarCommentCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"CarCommentCell"];
    //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //            cell.delegate = self;
    //            cell.model = _carCommentModel;
    //            return cell;
    //        } else {
    //            CollectionViewNoImageCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"CollectionViewNoImageCell"];
    //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //            cell.model = _carCommentModel;
    //            return cell;
    //        }
    //
    //    }
    else if (indexPath.row == 5) {  // Line
        cell.backgroundColor = [UIColor colorWithRed:0.918  green:0.918  blue:0.918 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return cell;
}

// 选中cell时触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        
    } else if (indexPath.row == 3) {
        BuyCarViewController *buyCarVC = [[BuyCarViewController alloc] init];
        buyCarVC.carId = self.carId;
        buyCarVC.type = self.type;
        buyCarVC.price = self.carDetailsModel.price;
        buyCarVC.dataModels = self.carDetailsModel.colorList;
        buyCarVC.marketPrice = self.carDetailsModel.marketPrice;
        buyCarVC.earnestMoney = self.carDetailsModel.earnestMoney;
        buyCarVC.selectIndex = self.colorSelectIndex;
        buyCarVC.buyCount = self.buyCount;
        buyCarVC.delegate = self;
        buyCarVC.motoPhoto = _photoMArray.count > 0 ? _photoMArray[0] : @"";
        [buyCarVC show];
    }
    //    else if (indexPath.row == 5) {
    //
    //        [self.scrollView scrollRectToVisible:CGRectMake(0, kUIScreenHeight, kUIScreenWidth, self.view.frame.size.height) animated:YES];
    //
    //        UIView *colorView = [self.headView viewWithTag:100];
    //        colorView.alpha = 1;
    //
    //        UILabel *label = [self.headView viewWithTag:101];
    //        label.alpha = colorView.alpha;
    //
    //        UIImageView *bgImageView = [self.headView viewWithTag:102];
    //        bgImageView.alpha = 1 - colorView.alpha;
    //
    //        [self.carDetailsSubVC.segment selectIndex:3];
    //        [self.carDetailsSubVC.flipView selectIndex:2];
    //
    //    }
    
}

#pragma mark BuyCarViewController代理
// 返回选中的颜色下标
- (void)buyCarViewController:(BuyCarViewController *)vc exitWithSelectIndex:(NSInteger)selectIndex andBuyCount:(int)buyCount{
    
    self.colorSelectIndex = selectIndex;
    self.buyCount = buyCount;
    
    if(self.carDetailsModel.colorList.count > self.colorSelectIndex ){
        
        CarColorListModel *colorModel1 = self.carDetailsModel.colorList[self.colorSelectIndex];
        if (colorModel1 && colorModel1.stock.intValue > 0 && buyCount <= colorModel1.stock.intValue) {
            
            self.selectInfo = [NSString stringWithFormat:@"已选择%@,数量:%d",colorModel1.colName,self.buyCount];
            
        }else{
            
            MBProgressHUD *hub = [[MBProgressHUD alloc] init];
            hub.labelText = @"库存不足,选择失败";
            hub.mode = MBProgressHUDModeText;
            [hub show:YES];
            [[UIApplication sharedApplication].keyWindow addSubview:hub];
            [hub hide:YES afterDelay:1];
            
        }
        
        
    }else{
        
        MBProgressHUD *hub = [[MBProgressHUD alloc] init];
        hub.labelText = @"库存不足,选择失败";
        hub.mode = MBProgressHUDModeText;
        [hub show:YES];
        [[UIApplication sharedApplication].keyWindow addSubview:hub];
        [hub hide:YES afterDelay:1];
        
    }
    
    
    [self.tableView reloadData];
}



#pragma mark - 底部视图点击事件
#pragma mark 电话 店铺 收藏 购物车 立即购买
//点击headView push到 ShopDetailsTableController控制器
- (void)bottomViewClickAction:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 1) {
        // 打电话
        if (_webView == nil) {
            _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        
        NSString *phoneStr = [NSString stringWithFormat:@"tel://%@", _carDetailsModel.phone];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneStr]]];
        
    }else if (tap.view.tag == 3) {   // 商品收藏
        
        //判断是否登录
        if (![YHUserInfo shareInstance].isLogin) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.loginOrReg = YES;
            YHNavigationController *loginView = [[YHNavigationController alloc] initWithRootViewController:loginVC];
            
            [self presentViewController:loginView animated:YES completion:nil];
            [self showMessage:LoginTipMessage delay:1];
            
            
        } else {
            //已经登录
            if (_isCollectState) {
                _isCollectState = NO;
                //取消商品收藏
                [self cancelCollectData];
            }else{
                _isCollectState = YES;
                //确认商品收藏
                [self addCollectData];
            }
        }
    }else { // 购物车
        if (![YHUserInfo shareInstance].isLogin) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.loginOrReg = YES;
            YHNavigationController *loginView = [[YHNavigationController alloc] initWithRootViewController:loginVC];
            
            [self presentViewController:loginView animated:YES completion:nil];
            [self showMessage:LoginTipMessage delay:1];
            
            
        } else {
            DefaultWebController *webVC = [[DefaultWebController alloc]init];
            
            NSString *service = [NSBundle mainBundle].bundleIdentifier;  // 获取唯一的字符标识
            
            //登录信息  账号和密码
            NSString *strPass = [NSString stringWithFormat:@"%@%@",[YHUserInfo shareInstance].uPhone,[SSKeychain passwordForService:service account:[YHUserInfo shareInstance].uPhone]];
            NSString *desStr = [JoDes encode:strPass key:kWebDESKey];
            
            
            
            //pid--新车或者活动的商品ＩＤ，attrId－颜色属性ＩＤ,num- 购买数量,  type- 类型0商城 1 2
            NSString *urlStr = [NSString stringWithFormat:@"%@%@&lg=%@",[[GetUrlString sharedManager] urlLoginWeb],[[GetUrlString sharedManager] urlShoppingCartWeb],desStr];
            
            
            webVC.urlStr = urlStr;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}

// 立即购买
-(void)buyClickAction:(UIButton *)button {
    
    //判断是否登录
    if (![YHUserInfo shareInstance].isLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.loginOrReg = YES;
        YHNavigationController *loginView = [[YHNavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:loginView animated:YES completion:nil];
        [self showMessage:LoginTipMessage delay:1];
        
        
    }else if([self.selectInfo isEqualToString:@"请选择颜色分类"]){
        BuyCarViewController *buyCarVC = [[BuyCarViewController alloc] init];
        buyCarVC.carId = self.carId;
        buyCarVC.type = self.type;
        buyCarVC.price = self.carDetailsModel.price;
        buyCarVC.dataModels = self.carDetailsModel.colorList;
        buyCarVC.marketPrice = self.carDetailsModel.marketPrice;
        buyCarVC.earnestMoney = self.carDetailsModel.earnestMoney;
        buyCarVC.selectIndex = self.colorSelectIndex;
        buyCarVC.buyCount = self.buyCount;
        buyCarVC.delegate = self;
        [buyCarVC show];
        
        
    }else {
        //已经登录
        DefaultWebController *mallVC = [[DefaultWebController alloc]init];
        
        CarColorListModel *colorModel1 = self.carDetailsModel.colorList[self.colorSelectIndex];
        
        
        //ac- 购买类型 (new--新车，活动车 action - 诚意金 zncl - 智能车联中的商品) pid-商品IDＩＤ，attrId－颜色属性ＩＤ,num- 购买数量,  type- 类型0商城 1 2
        NSString *urlStr = [NSString stringWithFormat:@"%@?ac=zncl&pid=%@&type=%@&attrId=%@&num=%d",[[GetUrlString sharedManager] urlBuyWeb],self.carId,self.type,[NSString stringWithFormat:@"%zd",colorModel1.colId],self.buyCount];
        
        mallVC.urlStr = [YHFunction getWebUrlWithUrl:urlStr];
        
        [self.navigationController pushViewController:mallVC animated:YES];
        
    }
}

#pragma mark - 商品收藏
#pragma mark  添加商品收藏
/// 添加商品收藏 collectBtnBlock
- (void)addCollectData{
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1063" forKey:@"rec_code"];
    
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; // 用户注册手机号
    
    [dictParam setValue:self.carId forKey:@"rec_id"]; // 商品Id（不能为空）
    [dictParam setValue:self.type forKey:@"rec_kind"]; // 0=商城,1=新车，2=活动车
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        
        if (error != nil) {
            [self showMessage: @"网络请求错误" delay:1];
        } else {
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                _imagCollView.image = [UIImage imageNamed:@"rec_collection_press"];
                [UserDefaultsTools setBool:YES forKey: goodsCollStr];
                NSString *collNum = [NSString stringWithFormat:@"%zd", _shopDetailsModel.collectionNum + 1];
                [UserDefaultsTools setObject:collNum forKey:goodsCollNum];
                [self showMessage:@"收藏成功" delay:0.5];
            }else {
                [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            }
            
        }
        return YES;
    }];
}
#pragma mark  取消商品收藏
/// 取消商品收藏 collectBtnBlock
- (void)cancelCollectData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1064" forKey:@"rec_code"];
    
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; // 用户注册手机号
    [dictParam setValue:self.carId forKey:@"rec_id"]; // 商品Id（不能为空）
    [dictParam setValue:self.type forKey:@"rec_kind"]; // 0=商城,1=新车，2=活动车
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        
        if (error != nil) {
            [self showMessage:@"网络请求错误" delay:1];
        } else {
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                _imagCollView.image = [UIImage imageNamed:@"rec_collection"];
                
                [UserDefaultsTools setBool:NO forKey: goodsCollStr];
                NSString *collNum = [NSString stringWithFormat:@"%zd", _shopDetailsModel.collectionNum - 1];
                [UserDefaultsTools setObject:collNum forKey:goodsCollNum];
                [self showMessage:@"取消收藏成功" delay:0.5];
                
            } else {
                [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:0.5];
            }
        }
        return YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
