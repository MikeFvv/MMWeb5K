//
//  GoodsCollectionController.m
//  YouCheLian
//
//  Created by Mike on 16/3/24.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "GoodsCollectionController.h"
#import "CarCollectionViewFlowLargeLayout.h"
#import "CarMoreCollectionViewCell.h"
#import "SaleShopDetailModels.h"
#import "SaleShopDetailModel.h"
#import "FoundCarDetailsViewController.h"
#import "ShopCollectionModels.h"
#import "SearchLeftGoodCell.h"
#import "GoodsCollectinLeftCell.h"
#import "ShopCollectionModel.h"


@interface GoodsCollectionController ()

@property (nonatomic, strong) CarCollectionViewFlowLargeLayout *largeLayout;

@property (nonatomic, strong) ShopCollectionModels *shopCollectionModels;
@property (nonatomic, strong) SaleShopDetailModels *saleShopDetailModels;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static NSString *ItemIdentifier = @"ItemIdentifier";

@implementation GoodsCollectionController

-(void)loadView
{
    [self initView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pageIndex = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor  = [UIColor colorWithRed:0.922  green:0.925  blue:0.929 alpha:1];
    
    [self getGoodsCollData];
    
    [self headerRefresh];
    [self footerRefresh];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GoodsCollectinLeftCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsCollectinLeftCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GoodsCollectinRightCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsCollectinRightCell"];
}




- (void)initView {
    
    
    
    
    
    self.largeLayout = [[CarCollectionViewFlowLargeLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.largeLayout];
    [self.collectionView registerClass:[CarMoreCollectionViewCell class] forCellWithReuseIdentifier:ItemIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    
    
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
    [self getGoodsCollData];
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
    if (self.dataArray.count < self.shopCollectionModels.res_pageTotalSize) {
        self.pageIndex++;
    }else{
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1014" forKey:@"rec_code"];
    [dictParam setValue: [YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:@"0" forKey:@"rec_type"]; // 0商品  3=商家
    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.pageIndex] forKey:@"rec_pageIndex"]; // 第几页,默认值1
    [dictParam setValue:@"10" forKey:@"rec_pageSize"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        //        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
            
            _shopCollectionModels = [ShopCollectionModels mj_objectWithKeyValues:result];
            
            [_dataArray addObjectsFromArray:_shopCollectionModels.dataList];
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
/// 获取收藏商家数据
- (void)getGoodsCollData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1014" forKey:@"rec_code"];
    [dictParam setValue: [YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:@"0" forKey:@"rec_type"]; // 0商品  3=商家
    [dictParam setValue:@"1" forKey:@"rec_pageIndex"];
    [dictParam setValue:@"10" forKey:@"rec_pageSize"];
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@", result);
        if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
            self.pageIndex = 1;
            _shopCollectionModels = [ShopCollectionModels mj_objectWithKeyValues:result];
            
            _dataArray = [NSMutableArray arrayWithArray:_shopCollectionModels.dataList];
            
            [self.collectionView reloadData];
        }
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.collectionView.mj_header endRefreshing];
        // 重置刷新提示内容
        [self.collectionView.mj_footer resetNoMoreData];
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
    NSString *recumeStr = nil;
    if (indexPath.row % 2 == 0) {
        recumeStr = @"GoodsCollectinLeftCell";
    }else{
        recumeStr = @"GoodsCollectinRightCell";
    }
    GoodsCollectinLeftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:recumeStr forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([self.delegate respondsToSelector:@selector(jumpGoodsDetailsDelegate:)]) {
        ShopCollectionModel *model = self.dataArray[indexPath.row];
        [self.delegate jumpGoodsDetailsDelegate:model.ID.stringValue];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

