//
//  InformationViewController.m
//  YouCheLian
//
//  Created by Mike on 15/11/26.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "ShopCollcctionController.h"
#import "ShopCollectionModels.h"
#import "ShopCollectionCell.h"
#import "ShopCollectionModel.h"

@interface ShopCollcctionController ()<UITableViewDelegate>

@property (nonatomic, strong) ShopCollectionModels *shopCollectionModels;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation ShopCollcctionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self getShopCollData];
    
    [self headerRefresh];
    [self footerRefresh];
}

- (void)initView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.922  green:0.925  blue:0.929 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _pageIndex = 1;
}




#pragma mark - 下拉刷新数据
- (void)headerRefresh
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    self.tableView.mj_header = refreshHeader;
    
    [refreshHeader setTitle:@"优宝君正在刷新中，请主人稍安勿躁 " forState:MJRefreshStateRefreshing];
}

#pragma mark - 下拉刷新 数据处理相关
- (void)loadNewData
{
    [self getShopCollData];
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
    
    self.tableView.mj_footer = refreshFooter;
}



#pragma mark - 上拉加载更多数据 分页
- (void)loadMoreUsedData {
    
    if (self.dataArray.count < self.shopCollectionModels.res_pageTotalSize) {
        self.pageIndex++;
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1014" forKey:@"rec_code"];
    [dictParam setValue: [YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:@"3" forKey:@"rec_type"]; // 0商品  3=商家
    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.pageIndex] forKey:@"rec_pageIndex"]; // 第几页,默认值1
    [dictParam setValue:@"10" forKey:@"rec_pageSize"];
    [dictParam setValue:@"10" forKey:@"rec_pageSize"];  // 每页多少条 默认值5
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        //        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
            
            _shopCollectionModels = [ShopCollectionModels mj_objectWithKeyValues:result];
            
            [_dataArray addObjectsFromArray:_shopCollectionModels.dataList];
            // 刷新表格
            [self.tableView reloadData];
            // 拿到当前的上拉刷新控件，结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        return YES;
    }];
}


#pragma mark - 请求数据
/// 获取商家数据
- (void)getShopCollData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1014" forKey:@"rec_code"];
    [dictParam setValue: [YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:@"3" forKey:@"rec_type"]; // 0商品  3=商家
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
            
            [self.tableView reloadData];
        }
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 重置刷新提示内容
        [self.tableView.mj_footer resetNoMoreData];
        return YES;
    }];
}


#pragma mark - Table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (self.dataArray.count == 0) { // // 还没收藏做一个提示cell
//        return 1;
//    }
    return self.dataArray.count;
}

// 设置每行高度 每一行 不是组
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.dataArray.count == 0) {  // 还没收藏做一个提示cell
//        return 0;
//    }
    return 156;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShopCollectionCell *cell = [ShopCollectionCell cellWithTableView:tableView];
    cell.model =  self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - TableView Delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([self.delegate respondsToSelector:@selector(jumpShopDetailsDelegate:)]) {
        ShopCollectionModel *model = self.dataArray[indexPath.row];
        [self.delegate  jumpShopDetailsDelegate:model.ID.stringValue];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
