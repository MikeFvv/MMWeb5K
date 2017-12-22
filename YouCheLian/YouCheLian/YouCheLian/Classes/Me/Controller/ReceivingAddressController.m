//
//  ReceivingAddressController.m
//  YouCheLian
//
//  Created by Mike on 15/11/24.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "ReceivingAddressController.h"
#import "ReceivingAddressCell.h"
#import "NewAddAddressController.h"
#import "ReceivingAddressModels.h"
#import "ReceivingAddressModel.h"


static NSString *cellID = @"ReceivingAddressCell";

@interface ReceivingAddressController ()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ReceivingAddressModels *receivingAddressModels;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger pageIndex;
//上拉刷新控件
@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshFooter;

@end

@implementation ReceivingAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNav];
    _dataArray = [NSMutableArray array];
    _pageIndex = 1;
    self.view.backgroundColor = kLightGrayColor;
    [self initViewBottom];
    
    [self.view addSubview:self.tableView];
    [self geAddressData];
    
    [self headerRefresh];
    [self footerRefresh];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceivingAddressCell" bundle:nil] forCellReuseIdentifier:cellID];
    
}



#pragma mark - 初始化 tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kUIScreenWidth ,kUIScreenHeight-kUINavHeight - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 隐藏分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        //去掉下面没有数据呈现的cell
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}


-(void)setNav {
    
    self.title = @"收货地址管理";
    // Nav 返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = kNav_Back_CGRectMake;
    [backBtn setImage:[UIImage imageNamed:@"Search_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
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
    [self geAddressData];
}

#pragma mark UITableView + 上拉刷新 加载更多
- (void)footerRefresh
{
    // 添加默认的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsedData)];
    self.refreshFooter = refreshFooter;
   
    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStatePulling];
    [refreshFooter setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateWillRefresh];
    [refreshFooter setTitle:@"已显示全部内容" forState:MJRefreshStateNoMoreData];
    
    self.tableView.mj_footer = refreshFooter;
}



#pragma mark - 上拉加载更多数据 分页
- (void)loadMoreUsedData {
    
    if (self.dataArray.count < self.receivingAddressModels.res_pageTotalSize) {
        self.pageIndex++;
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1012" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; // 注册用户号
    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.pageIndex] forKey:@"rec_pageIndex"]; // 第几页,默认值1
    [dictParam setValue:@"10" forKey:@"rec_pageSize"];  // 每页多少条 默认值5
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        //        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
            
            _receivingAddressModels = [ReceivingAddressModels mj_objectWithKeyValues:result];
            
            [_dataArray addObjectsFromArray:_receivingAddressModels.dataList];
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


#pragma mark - 请求数据 收货地址
/// 收货地址
- (void)geAddressData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1012" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; // 注册用户号
    [dictParam setValue:@"1" forKey:@"rec_pageIndex"];  // 第几页 默认1
    [dictParam setValue:@"10" forKey:@"rec_pageSize"];  // 每页多少条 默认值5
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    NSLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@", result);
        if (error) {
            
        } else {
            if ([result[@"res_num"] isEqualToString:@"0"] || [result[@"res_num"] isEqualToString:@"-1"]) {  // 成功
                _pageIndex = 1;
                _receivingAddressModels = [ReceivingAddressModels mj_objectWithKeyValues:result];
                _dataArray = [NSMutableArray arrayWithArray:_receivingAddressModels.dataList];
                
                self.refreshFooter.hidden = NO;
                //设置上拉刷新默认提示
                if (self.dataArray.count == 0) {
                    [self.refreshFooter setTitle:@"请新建地址" forState:MJRefreshStateIdle];
                }else if(self.dataArray.count > 7){
                    [self.refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
                }else{
                    self.refreshFooter.hidden = YES;
                }
                
             }else {
                [self.refreshFooter setTitle:@"加载失败" forState:MJRefreshStateIdle];
                [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            }
        }
        
        // 刷新表格
        [self.tableView reloadData];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        
        // 重置上拉刷新状态
        [self.tableView.mj_footer resetNoMoreData];

        return YES;
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceivingAddressModel *model = self.dataArray[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceivingAddressCell *cell = [ReceivingAddressCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - 更改收货地址
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 更改收货地址
    NewAddAddressController *vc = [[NewAddAddressController alloc] init];
    vc.isNewAdd = 1;
    vc.title = @"修改收货地址";
    //成功的回调
    __weak typeof(self) weakSelf = self;
    vc.addressSuccessBlock = ^(){
        //刷新当前界面数据
        [weakSelf geAddressData];
        
        
    };
    vc.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 新增 入口
// 新增收货地址
-(void)onAddBtn:(UIButton *)sender {
    
    NewAddAddressController *vc = [[NewAddAddressController alloc] init];
    vc.isNewAdd = 0;
    vc.title = @"新建收货地址";
    
    // 成功的回调
    __weak typeof(self) weakSelf = self;
    vc.addressSuccessBlock = ^(){
        //刷新当前界面数据
        [weakSelf geAddressData];
        
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - View底部
// View底部
- (void)initViewBottom {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kUIScreenHeight-49 - kUINavHeight, kUIScreenWidth, 49)];
    bottomView.backgroundColor = kNavColor;
    [self.view addSubview:bottomView];
    
    /**** 新增保存地址 ****/
    UIButton *saveBtn = [[UIButton alloc] init];
    [saveBtn setTitle:@"新建地址" forState:UIControlStateNormal];
    saveBtn.backgroundColor = kColorDarkGreen;
    [saveBtn addTarget:self action:@selector(onAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    saveBtn.layer.cornerRadius = 5;
    [bottomView addSubview:saveBtn];
    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomView.mas_centerX);
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kUIScreenWidth/2, 35));
    }];
}



-(void)onBackBtn:(UIButton *)sender {
    // 将栈顶的控制器移除
    [self.navigationController popViewControllerAnimated:YES];
}

@end



