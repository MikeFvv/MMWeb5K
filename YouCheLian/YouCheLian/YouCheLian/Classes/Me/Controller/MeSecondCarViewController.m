//
//  MeSecondCarViewController.m
//  YouCheLian
//
//  Created by Mike on 16/3/28.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "MeSecondCarViewController.h"
#import "MeSecondCarCell.h"
#import "UsedCarModels.h"
#import "UsedCarModel.h"
#import "UsedCarDetailsController.h"
#import "DefaultWebController.h"
#import "ReleaseViewController.h"

@interface MeSecondCarViewController ()<UITableViewDataSource,UITableViewDelegate,MeSecondCarCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
/**数据源*/
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) UsedCarModels *usedCarModels;

@property (nonatomic, strong) UsedCarModel *usedCarModel;

@property (nonatomic, strong) NSMutableArray *usedCarArray;

@property (nonatomic, strong) MeSecondCarCell *deleteCell;

//上拉刷新控件
@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshFooter;

@end

@implementation MeSecondCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self initNav];
    
    //创建视图
    [self initView];
    
    //上下拉刷新
    [self headerRefresh];
    [self footerRefresh];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获得shuju
    [self getUsedCar];
}

#pragma mark - 初始化视图
- (void)initView{
    
    //初始化tableView
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.914  green:0.918  blue:0.922 alpha:1];
    [self.view addSubview:self.tableView];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MeSecondCarCell" bundle:nil] forCellReuseIdentifier:@"MeSecondCarCell"];
    
    //设置上拉刷新
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    
    self.tableView.mj_footer.hidden = YES;
    
    
}

#pragma mark - 设置导航栏
- (void)initNav{
    self.title = @"二手车信息";

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
    [self getUsedCar];
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
    
    if (self.usedCarArray.count < self.usedCarModels.res_pageTotalSize) {
        self.pageIndex++;
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    // 创建一个空字典
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1040" forKey:@"rec_code"];
    [dictParam setValue:@"0" forKey:@"rec_kind"]; // 商品类别编码（如：摩托车，电动车。《数据字典中的Dic_ID》
    [dictParam setValue:@"0" forKey:@"rec_type"]; // 分类编码(数据字典中的Dic_ID)
    [dictParam setValue:@"0" forKey:@"rec_brand"]; // 品牌(数据字典中的dic_id)
    [dictParam setValue:@"0" forKey:@"rec_price"]; // 价格
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; // 价格
    
    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.pageIndex] forKey:@"rec_pageIndex"]; // 第几页,默认值1
    [dictParam setValue:@"10" forKey:@"rec_pageSize"]; // 每页多少条，默认值5
    
   
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        //        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
            
            _usedCarModels = [UsedCarModels mj_objectWithKeyValues:result];
            [_usedCarArray addObjectsFromArray:_usedCarModels.dataList];
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
/// 获取数据
- (void)getUsedCar {
    
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1040" forKey:@"rec_code"];
    [dictParam setValue:@"0" forKey:@"rec_kind"]; // 商品类别编码（如：摩托车，电动车。《数据字典中的Dic_ID》
    [dictParam setValue:@"0" forKey:@"rec_type"]; // 分类编码(数据字典中的Dic_ID)
    [dictParam setValue:@"0" forKey:@"rec_brand"]; // 品牌(数据字典中的dic_id)
    [dictParam setValue:@"0" forKey:@"rec_price"]; // 价格
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; // 价格
    
    [dictParam setValue:@"1" forKey:@"rec_pageIndex"]; // 第几页,默认值1
    [dictParam setValue:@"10" forKey:@"rec_pageSize"]; // 每页多少条，默认值5
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if (error) {
            
        }else {
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                _pageIndex = 1;
                _usedCarModels = [UsedCarModels mj_objectWithKeyValues:result];
                _usedCarArray = [NSMutableArray arrayWithArray:_usedCarModels.dataList];
                
            }else {
                
//                [self showMessage:result[@"res_desc"] delay:1.0];
                
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

//删除二手车信息
-(void)sendDeleteRequset:(NSString *)rec_id {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1068" forKey:@"rec_code"];
    
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; //手机号
    
    [dictParam setValue:rec_id forKey:@"rec_id"]; // 二手车Id
    
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) {
            // 成功
            [self showMessage:result[@"res_desc"] delay:1.0];
            [self.usedCarArray removeObject:self.deleteCell.model];
        }else {
            
            [self showMessage:result[@"res_desc"] delay:1.0];
            
        }
        
        [self.tableView reloadData];
        
        
        return YES;
    }];

}




#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.usedCarArray.count;
}

//动态计算高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MeSecondCarCell";
    
    //返回空CELL
    MeSecondCarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MeSecondCarCell alloc] init];
    }
    cell.delegate = self;
    cell.model = self.usedCarArray[indexPath.row];
    return cell;
}

//二手车详情跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UsedCarDetailsController *vc = [[UsedCarDetailsController alloc] init];
    vc.usedCarModel = self.usedCarArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 置顶
//点击了置顶按钮
- (void)meSecondCarCellDidTopBtnClick:(MeSecondCarCell *)cell {
    
    DefaultWebController *menuWebVC = [[DefaultWebController alloc]init];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@?pid=%@",[[GetUrlString sharedManager] urlBuyTop],cell.model.infoid.stringValue];
    
        menuWebVC.urlStr = [YHFunction getWebUrlWithUrl:urlStr];
        menuWebVC.title = @"支付";
        menuWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:menuWebVC animated:YES];
    
    
}
#pragma mark - 编辑
//点击了编辑按钮
- (void)meSecondCarCellDidEditBtnClick:(MeSecondCarCell *)cell {
    ReleaseViewController *vc = [[ReleaseViewController alloc] init];
    //二手车类型
    vc.releaseType = cell.model.kind;
    //model存在为编辑
    vc.model = cell.model;
    vc.isEdit = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

#pragma mark - 删除
//点击了删除按钮
- (void)meSecondCarCellDidDeleteBtnClick:(MeSecondCarCell *)cell {
    self.deleteCell = cell;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"真的要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}



// 退出登录 定义的委托，buttonindex就是按下的按钮的index值
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"1");
        [self sendDeleteRequset:self.deleteCell.model.infoid.stringValue];
        
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
