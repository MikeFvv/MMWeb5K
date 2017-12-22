//
//  MeSystemMessageController.m
//  YouCheLian
//
//  Created by Mike on 16/3/23.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "MeSystemMessageController.h"
#import "MeSystemMessageCell.h"
#import "MeSystemMessageModels.h"


@interface MeSystemMessageController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation MeSystemMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MeSystemMessageCell" bundle:nil] forCellReuseIdentifier:@"MeSystemMessageCell"];
    
    [self getData];
    
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
    [self getData];
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
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1069" forKey:@"rec_code"];
    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.pageIndex] forKey:@"rec_pageIndex"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"字符串===%@",dictParam);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            self.pageIndex++;
            MeSystemMessageModels *dataModel = [MeSystemMessageModels mj_objectWithKeyValues:result];
            
            [self.dataArray addObjectsFromArray: dataModel.DataList];
            
            // 拿到当前的上拉刷新控件，结束刷新状态
            [self.tableView.mj_footer endRefreshing];
            // 刷新表格
            [self.tableView reloadData];
            
        }else {
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        
        return YES;
    }];

    
}

#pragma mark - 获得数据
-(void)getData {
    
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1069" forKey:@"rec_code"];
    [dictParam setValue:@"1" forKey:@"rec_pageIndex"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"字符串===%@",dictParam);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@",result);
        
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            self.pageIndex = 1;
            self.pageIndex++;
            MeSystemMessageModels *dataModel = [MeSystemMessageModels mj_objectWithKeyValues:result];
            self.dataArray = [NSMutableArray arrayWithArray:dataModel.DataList];
            
            [self.tableView reloadData];
        }else {
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
        }

        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        
        return YES;
    }];

    
    
    
}


#pragma mark - 初始化tableView

- (void)initTableView{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    
}

#pragma mark - tableViewDelegate

/// 返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

// 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    CarCommentModel *message = _dataArray[indexPath.row];
    return 90;
}

// 返回cell 视图
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MeSystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeSystemMessageCell"];
    cell.model = self.dataArray[indexPath.row];
        
    return cell;
 
}

// 选中cell时触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(meSystemMessageController:didSelectRowAtIndexPath:)]) {
        [self.delegate meSystemMessageController:self didSelectRowAtIndexPath:indexPath];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
