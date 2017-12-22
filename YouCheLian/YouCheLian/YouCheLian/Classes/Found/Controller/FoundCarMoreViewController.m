//
//  AFViewController.m
//  UICollectionViewFlowLayoutExample
//
//  Created by Ash Furrow on 2013-02-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "FoundCarMoreViewController.h"
#import "CarCollectionViewFlowLargeLayout.h"
#import "CarMoreCollectionViewCell.h"
#import "SaleShopDetailModels.h"
#import "SaleShopDetailModel.h"
#import "FoundCarDetailsViewController.h"


@interface FoundCarMoreViewController ()

@property (nonatomic, strong) CarCollectionViewFlowLargeLayout *largeLayout;

@property (nonatomic, strong) SaleShopDetailModel *saleShopDetailModel;
@property (nonatomic, strong) SaleShopDetailModels *saleShopDetailModels;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static NSString *ItemIdentifier = @"ItemIdentifier";

@implementation FoundCarMoreViewController

-(void)loadView
{
    [self initView];
    [self setNav];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self getGoodData];
    
    [self headerRefresh];
    [self footerRefresh];
}

-(void)setNav {
    self.title = @"优惠车型";
    
    
    // 设置title的字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:kNavTitleFont18,
       NSForegroundColorAttributeName:kFontColor}];
    
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
    // 在push控制器时显示UITabBar
    //    self.hidesBottomBarWhenPushed = NO;
    // 将栈顶的控制器移除
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initView {
    
    self.largeLayout = [[CarCollectionViewFlowLargeLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.largeLayout];
    [self.collectionView registerClass:[CarMoreCollectionViewCell class] forCellWithReuseIdentifier:ItemIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    
    self.collectionView.backgroundColor  = [UIColor colorWithRed:0.922  green:0.925  blue:0.929 alpha:1];
    
    
}

/**
 *  当控制器的view即将显示的时候调用
 */
- (void)viewWillAppear:(BOOL)animated {
    // 显示导航栏
    self.navigationController.navigationBar.hidden = NO;
    
    // 设置title的字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:kNavTitleFont18,
       NSForegroundColorAttributeName:kFontColor}];
}






#pragma mark - 下拉刷新数据
- (void)headerRefresh
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    self.collectionView.mj_header = refreshHeader;

    [refreshHeader setTitle:@"优宝君正在刷新中，请主人稍安勿躁 " forState:MJRefreshStateRefreshing];
   
}

#pragma mark - 下拉刷新 数据处理相关
- (void)loadNewData
{
    [self getGoodData];
}

#pragma mark UITableView + 上拉刷新 加载更多
- (void)footerRefresh
{
    // 添加默认的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsedData)];
    
    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStatePulling];
    [refreshFooter setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateWillRefresh];
    [refreshFooter setTitle:@"已显示全部内容" forState:MJRefreshStateNoMoreData];
    
    self.collectionView.mj_footer = refreshFooter;
}


#pragma mark - 上拉加载更多数据 分页
///获取更多数据
- (void)loadMoreUsedData {
    if (self.dataArray.count < self.saleShopDetailModels.res_pageTotalSize) {
        self.pageIndex++;
    }else{
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1050" forKey:@"rec_code"];
    
    [dictParam setValue: [YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; //注册用户号
    [dictParam setValue:self.shopId forKey:@"rec_id"]; // 商家id
    [dictParam setValue:@"" forKey:@"rec_key"]; // 模糊搜索关键词
    
    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.pageIndex] forKey:@"rec_pageIndex"]; // 第几页,默认值1
    [dictParam setValue:@"10" forKey:@"rec_pageSize"]; // 每页多少条，默认值5
    
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        //        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
            
            _saleShopDetailModels = [SaleShopDetailModels mj_objectWithKeyValues:result];
            
            [_dataArray addObjectsFromArray:_saleShopDetailModels.dataList];
            // 刷新表格
            [self.collectionView reloadData];
            // 拿到当前的上拉刷新控件，结束刷新状态
            [self.collectionView.mj_footer endRefreshing];
        }else{
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        return YES;
    }];
}





#pragma mark - 请求数据
/// 获取商品数据
- (void)getGoodData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1050" forKey:@"rec_code"];
    
    [dictParam setValue: [YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; //注册用户号
    [dictParam setValue:self.shopId forKey:@"rec_id"]; // 商家id
    [dictParam setValue:@"" forKey:@"rec_key"]; // 模糊搜索关键词
    
    [dictParam setValue:@"1" forKey:@"rec_pageIndex"]; // 第几页,默认值1
    [dictParam setValue:@"10" forKey:@"rec_pageSize"]; // 每页多少条，默认值5
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    //    [self showLoadingView];
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        
        if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
            _pageIndex = 1;
            [self.collectionView.mj_footer resetNoMoreData];
            
            _saleShopDetailModels = [SaleShopDetailModels mj_objectWithKeyValues:result];
            _dataArray = [NSMutableArray arrayWithArray:_saleShopDetailModels.dataList];
            // 刷新表格
            [self.collectionView reloadData];
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.collectionView.mj_header endRefreshing];
        }
        
        //        [self hidenLoadingView];
        
        if (self.dataArray.count == 0 || self.dataArray == nil) {
            //            [self showMessage:@"没有数据" delay:1];
        }
        
        return YES;
    }];
}


#pragma mark - UICollectionView DataSource & Delegate methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CarMoreCollectionViewCell *cell = (CarMoreCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ItemIdentifier forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //车辆详情
    FoundCarDetailsViewController *vc = [[FoundCarDetailsViewController alloc] init];
    SaleShopDetailModel *model =  self.dataArray[indexPath.row];
    vc.carId = [NSString stringWithFormat:@"%zd",model.carId];
    vc.type = @"1";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
