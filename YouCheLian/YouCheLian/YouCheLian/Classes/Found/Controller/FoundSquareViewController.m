//
//  FoundSquareViewController.m
//  YouCheLian
//
//  Created by Mike on 16/3/16.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FoundSquareViewController.h"
#import "FoundSquareModels.h"
#import "FoundSquareModel.h"
#import "FoundSquareCommentCell.h"
#import "FoundSquareNoIconCommentCell.h"
#import "LoginViewController.h"
#import "YHNavigationController.h"

@interface FoundSquareViewController ()<FoundSquareCommentCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) FoundSquareModels *foundSquareModels;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) FoundSquareModel *tempModel;

@property (nonatomic, strong) UIButton *tempBtn;


@end

@implementation FoundSquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 去除选中状态
    self.clearsSelectionOnViewWillAppear = YES;
    
    //我的评论，和我的发现才调用
    if (self.squareType){
        [self getSquareData];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FoundSquareCommentCell" bundle:nil] forCellReuseIdentifier:@"FoundSquareCommentCell"];
    
    [self headerRefresh];
    [self footerRefresh];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
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
    [self getSquareData];
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
    [dictParam setValue:@"1072" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:self.squareType forKey:@"rec_type"];
    
    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.pageIndex] forKey:@"rec_pageIndex"]; // 第几页,默认值1
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            self.pageIndex++;
            _foundSquareModels = [FoundSquareModels mj_objectWithKeyValues:result];
            
            [self.dataArray addObjectsFromArray: _foundSquareModels.dataList];
            
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///发现列表请求
- (void)getSquareData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1072" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:self.squareType forKey:@"rec_type"];  // 2
    [dictParam setValue:@"1" forKey:@"rec_pageIndex"];
    
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            self.pageIndex = 1;
            self.pageIndex++;
            
            _foundSquareModels = [FoundSquareModels mj_objectWithKeyValues:result];
            
            self.dataArray = [NSMutableArray arrayWithArray:_foundSquareModels.dataList];
            // 刷新表格
            [self.tableView reloadData];
            //重置上拉刷新状态
            [self.tableView.mj_footer resetNoMoreData];
        }else {
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
        }
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        
        return YES;
    }];
}




///弹窗方法
- (void)showMessage:(NSString *)message delay:(NSTimeInterval)delay {
    MBProgressHUD *hub = [[MBProgressHUD alloc] init];
    hub.mode = MBProgressHUDModeText;
    hub.labelText = message;
    [hub show:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:hub];
    [hub hide:YES afterDelay:delay];
}

#pragma mark - 评价图片点击代理回调

- (void)foundSquareCommentCellCell:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imagArray:(NSArray *)imagArray{
    
    if ([self.delegate respondsToSelector:@selector(FoundSquareViewCell:didSelectItemAtIndexPath:imagArray:)]) {
        [self.delegate FoundSquareViewCell:collectionView didSelectItemAtIndexPath:indexPath imagArray:imagArray];
    }
}

//删除按钮点击
- (void)FoundSquareCommentCellDidClickDeleteBtn:(UIButton *)btn withModel:(FoundSquareModel *)model{
    
    self.tempBtn = btn;
    self.tempModel = model;
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定删除?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    
    
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        // 取消登录选择
    } else {
        
        self.tempBtn.userInteractionEnabled = NO;
        
        
        //删除我的发现
        [self sendDeleteSquareRequestWithModel:self.tempModel withBtn:self.tempBtn];
        
        
    }
    
    

}


//点赞按钮点击
- (void)FoundSquareCommentCellDidClickUpvoteNumBtn:(UIButton *)btn withModel:(FoundSquareModel *)model{
    
    if ([YHUserInfo shareInstance].isLogin) {  // 是否登录
        //发送点赞请求
        [self sendUpvoteRequest:model withBtn:btn];
        
    } else {  // 没登录  跳转到登录页面
        
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.loginOrReg = YES;
        YHNavigationController *navVc = [[YHNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navVc animated:YES completion:nil];
        
    }
    
    
    
}


#pragma mark - 网络请求
//删除发现请求
- (void)sendDeleteSquareRequestWithModel:(FoundSquareModel *)model withBtn:(UIButton *)btn{
    
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1078" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:model.ID.stringValue forKey:@"rec_id"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@",result);
        
        btn.userInteractionEnabled = YES;
        
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            //删除成功
            [self.dataArray removeObject:model];
            
            [self.tableView reloadData];
            
            
        }else {
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
        }

        
        return YES;
    }];
    

    
}



//发送点赞请求
- (void)sendUpvoteRequest:(FoundSquareModel *)model withBtn:(UIButton *)btn{
    
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1076" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:model.ID.stringValue forKey:@"rec_id"];
    
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            //点赞成功更新ui
            btn.selected = !btn.selected;
            model.isUpvote = !model.isUpvote;
            if(btn.selected){
                model.upvoteNum++;
            }else{
                model.upvoteNum--;
            }
            [btn setTitle:[NSString stringWithFormat:@"%d",model.upvoteNum] forState:UIControlStateNormal];
            
            
        }else {
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
        }
        
        
        
        return YES;
    }];
    
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
    
    FoundSquareModel *model = _dataArray[indexPath.row];
    return model.cellHeight;
}
//
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //获取模型
    FoundSquareModel *model = self.dataArray[indexPath.row];
    
    if (model.lstImage.count == 0) {
        
        static NSString *cellID = @"FoundSquareNoIconCommentCell";
        FoundSquareNoIconCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [FoundSquareNoIconCommentCell cellWithTableView:tableView];
            
        }
        cell.model = self.dataArray[indexPath.row];
        cell.delegate = self;
        if([self.squareType isEqualToString:@"1"] ){
            
            cell.deleteBtn.hidden = NO;
        }
        
        return cell;
        
    }else {
        
        static NSString *cellID = @"FoundSquareCommentCell";
        FoundSquareCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [FoundSquareCommentCell cellWithTableView:tableView];
            
        }
        cell.model = self.dataArray[indexPath.row];
        cell.delegate = self;
        if([self.squareType isEqualToString:@"1"] ){
            
            cell.deleteBtn.hidden = NO;
        }
        
        return cell;
    }
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([self.delegate respondsToSelector:@selector(foundSquareViewController:didSelectRowAtIndexPath:withModel:)]) {
        
        FoundSquareModel *model = self.dataArray[indexPath.row];
        
        [self.delegate foundSquareViewController:self didSelectRowAtIndexPath:indexPath withModel:model];
        
    }
    
    
}



@end
