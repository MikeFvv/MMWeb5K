//
//  FoundShopViewController.m
//  YouCheLian
//
//  Created by Mike on 16/3/16.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FoundShopViewController.h"
#import "SearchShopCell.h"
#import "SearchModels.h"




@interface FoundShopViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) SearchModels *searchModels;

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation FoundShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    
    
    [self getSearchShopData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchShopCell" bundle:nil] forCellReuseIdentifier:@"SearchShopCell"];
    [self headerRefresh];
    [self footerRefresh];
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
    [self getSearchShopData];
}

#pragma mark UITableView + 上拉刷新 加载更多
- (void)footerRefresh
{
    // 添加默认的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStatePulling];
    [refreshFooter setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateWillRefresh];
    [refreshFooter setTitle:@"已显示全部内容" forState:MJRefreshStateNoMoreData];
    
    self.tableView.mj_footer = refreshFooter;
}

#pragma mark - 上拉加载更多数据 分页
/// 获取更多数据
- (void)loadMoreData {
    if (self.dataArray.count < self.searchModels.res_pageTotalSize) {
        self.pageIndex++;
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1011" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:@"1" forKey:@"rec_sysId"]; // 默认设备：1：摩托车，2=智能后视镜，3=行车记录仪，4=超长待机（为用户的精准推送预留）
    //获得自己当前百度坐标
    CLLocationCoordinate2D coord = [[YHLocationManager shareInstance] BDlocation];
    [dictParam setValue:[NSString stringWithFormat:@"%f",coord.latitude] forKey:@"rec_lat"];
    [dictParam setValue:[NSString stringWithFormat:@"%f",coord.longitude] forKey:@"rec_lng"];
    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.pageIndex] forKey:@"rec_pageIndex"]; // 第几页,默认值1
    [dictParam setValue:@"10" forKey:@"rec_pageSize"];
    [dictParam setValue:@"0" forKey:@"rec_merchType"];
    [dictParam setValue:@"0" forKey:@"rec_type"];
    [dictParam setValue:@"" forKey:@"rec_key"];
    [dictParam setValue:@"0" forKey:@"rec_distince"];
    [dictParam setValue:@"0" forKey:@"res_filter"];
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];

    NSLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            _searchModels = [SearchModels mj_objectWithKeyValues:result];
            
            [self.dataArray addObjectsFromArray: _searchModels.dataList];
            
            // 拿到当前的上拉刷新控件，结束刷新状态
            [self.tableView.mj_footer endRefreshing];
            // 刷新表格
            [self.tableView reloadData];
            
        }else {
            
//            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        return YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///搜索商家请求
- (void)getSearchShopData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1011" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:@"1" forKey:@"rec_sysId"];
    //获得自己当前百度坐标
    CLLocationCoordinate2D coord = [[YHLocationManager shareInstance] BDlocation];
    [dictParam setValue:[NSString stringWithFormat:@"%f",coord.latitude] forKey:@"rec_lat"];
    [dictParam setValue:[NSString stringWithFormat:@"%f",coord.longitude] forKey:@"rec_lng"];
    [dictParam setValue:@"1" forKey:@"rec_pageIndex"];
    [dictParam setValue:@"10" forKey:@"rec_pageSize"];
    [dictParam setValue:@"0" forKey:@"rec_merchType"];
    [dictParam setValue:@"0" forKey:@"rec_type"];
    [dictParam setValue:@"" forKey:@"rec_key"];
    [dictParam setValue:@"0" forKey:@"rec_distince"];
    [dictParam setValue:@"0" forKey:@"res_filter"];
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];

    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            _pageIndex = 1;
            _searchModels = [SearchModels mj_objectWithKeyValues:result];
            
            self.dataArray = [NSMutableArray arrayWithArray:_searchModels.dataList];
            //重置上拉刷新状态
            [self.tableView.mj_footer resetNoMoreData];

        }else {
            
//            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            
        }
        // 刷新表格
        [self.tableView reloadData];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        
        return YES;
    }];
}


//弹窗方法
- (void)showMessage:(NSString *)message delay:(NSTimeInterval)delay {
    MBProgressHUD *hub = [[MBProgressHUD alloc] init];
    hub.mode = MBProgressHUDModeText;
    hub.labelText = message;
    [hub show:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:hub];
    [hub hide:YES afterDelay:delay];
}


#pragma mark - UITableViewDelegate - 子类重写
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

//动态计算高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 155;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SearchShopCell";
        
        SearchShopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[SearchShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
        }
        cell.model = self.dataArray[indexPath.row];
        
        return cell;
        
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Cell 选中效果取消
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 商家详情
    if ([self.delegate respondsToSelector:@selector(didSelectJumpFoundShopDelegateModel:)]) {
        SearchModel *model = self.dataArray[indexPath.row];
        [self.delegate didSelectJumpFoundShopDelegateModel:model];
    }
}





@end
