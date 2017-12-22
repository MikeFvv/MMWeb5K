//
//  FoundDetailsController.m
//  YouCheLian
//
//  Created by Mike on 16/3/19.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FoundDetailsController.h"
#import "FoundDetailsCommentCell.h"
#import "FoundSquareNoIconCommentCell.h"
#import "FoundSquareCommentCell.h"
#import "ZLPhoto.h"
#import "CommentCollectionViewCell.h"
#import "FoundDetailsModel.h"
#import "FoundCommentsModel.h"
#import "FoundCommentModel.h"
//判断是否登录
#import "LoginViewController.h"
#import "YHNavigationController.h"


#import "UITextView+Select.h"

#define kBottomHeight 48

@interface FoundDetailsController ()<UITableViewDelegate,UITableViewDataSource,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,FoundSquareCommentCellDelegate,FoundDetailsCommentCellDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>


@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *commentDataArray;

@property (nonatomic, strong) UICollectionView  *collectionView;

@property (nonatomic, strong) FoundDetailsModel *foundDetailsModel;

@property (nonatomic, strong) FoundCommentsModel *foundCommentsModel;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) UITextView *bottomTextView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong) UIButton *upvoteBtn;

@property (nonatomic, strong) UITapGestureRecognizer *gesture;

@end

@implementation FoundDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setNav];
    
    //初始化View
    [self initView];
    
    //得到详情数据
    [self getDetailsData];
    
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
    [self getDetailsData];
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
    [dictParam setValue:@"1075" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.ID] forKey:@"rec_id"];
    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.pageIndex] forKey:@"rec_pageIndex"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            self.pageIndex++;
            _foundCommentsModel = [FoundCommentsModel mj_objectWithKeyValues:result];
            
            [_commentDataArray addObjectsFromArray:_foundCommentsModel.dataList];
            
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

#pragma mark - 初始化View

- (void)initView {
    
    //初始化tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"FoundSquareCommentCell" bundle:nil] forCellReuseIdentifier:@"FoundSquareCommentCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FoundSquareNoIconCommentCell" bundle:nil] forCellReuseIdentifier:@"FoundSquareNoIconCommentCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FoundDetailsCommentCell" bundle:nil] forCellReuseIdentifier:@"FoundDetailsCommentCell"];
    
    //底部输入栏
    UIView *bottomToolView  = [[UIView alloc] init];
    bottomToolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomToolView];
    self.bottomView = bottomToolView;
    
    [bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    //分隔线
    UIView *line = [[UIView alloc] init];
    line.alpha = 0.3;
    line.backgroundColor = [UIColor lightGrayColor];
    [bottomToolView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomToolView.mas_top);
        make.left.mas_equalTo(bottomToolView.mas_left);
        make.right.mas_equalTo(bottomToolView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    //点赞按钮
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setImage:[UIImage imageNamed:@"Found_bottom_like_line"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"Found_bottom_like_full"] forState:UIControlStateSelected];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.isUpvote) {
        leftBtn.selected = YES;
    }else{
        leftBtn.selected = NO;
    }
    [bottomToolView addSubview:leftBtn];
    self.upvoteBtn = leftBtn;
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomToolView.mas_centerY);
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        
    }];
    
    //发送按钮
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.frame = CGRectMake(0, 0, 44, 28);
    rightBtn.layer.cornerRadius = 28 / 2;
    rightBtn.layer.borderWidth = 0.5;
    rightBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [rightBtn setBackgroundColor:[UIColor colorWithRed:0.914  green:0.918  blue:0.922 alpha:1]];
    rightBtn.enabled = NO;
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolView addSubview:rightBtn];
    self.sendBtn = rightBtn;
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomToolView.mas_centerY);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(28);
        
    }];
    
    //textView
    UITextView *views = [[UITextView alloc] init];
    views.backgroundColor = [UIColor colorWithRed:0.969  green:0.973  blue:0.976 alpha:1];
    //    views.placeholder = @"写评论...";
    views.delegate = self;
    views.layer.cornerRadius = 5;
    views.font = YHFont(16, NO);
    [bottomToolView addSubview:views];
    self.bottomTextView = views;
    
    
    [views mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomToolView.mas_centerY);
        make.left.mas_equalTo(leftBtn.mas_right).offset(15);
        make.right.mas_equalTo(rightBtn.mas_left).offset(-15);
        make.height.mas_equalTo(36);
    }];
    
    
    //设置约束
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(bottomToolView.mas_top);
        
    }];
    
    
    
    
}


#pragma mark - UITextView 代理
- (void)textViewDidChange:(UITextView *)textView {
    
    // 在这个地方计算输入的字数
#pragma mark 超过200字不能输入
    if ([textView getInputLengthWithText:nil] > kCharNum) {
        textView.text = [textView.text substringToIndex:kCharNum];
    }
    
    CGFloat textviewH = 0;
    CGFloat minHeight = 34;   // 1行
    CGFloat maxHeight = 106;  // 5行
    
    CGFloat contentHeight = textView.contentSize.height;
    YHLog(@"======%f", contentHeight);
    
    if (contentHeight < minHeight) {
        textviewH = minHeight;
    }else if(contentHeight > maxHeight){
        textviewH = maxHeight;
    }else{
        textviewH = contentHeight;
    }
    
    // 按下回车键的时候才走这里
    if ([textView.text hasSuffix:@"\n"]) {
        
        [self.bottomView resignFirstResponder];
        
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textviewH+(kBottomHeight - minHeight));
        }];
        
        [self.bottomTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textviewH);
        }];
        
        [self.view layoutIfNeeded];
        
    }];
    
    if (textView.text.length > 0) {
        
        [self.sendBtn setBackgroundColor:[UIColor colorWithRed:0.588  green:0.776  blue:0.145 alpha:1]];
        [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        self.sendBtn.enabled = YES;
        
    }else{
        
        [self.sendBtn setBackgroundColor:[UIColor colorWithRed:0.914  green:0.918  blue:0.922 alpha:1]];
        [self.sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        self.sendBtn.enabled = NO;
    }
    
    
}


#pragma mark - 底部按钮点击
- (void)leftBtnClick:(UIButton *)btn {
    if ([YHUserInfo shareInstance].isLogin) {  // 是否登录
        //发送点赞请求
        [self sendUpvoteRequest];
    } else {  // 没登录  跳转到登录页面
        
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.loginOrReg = YES;
        YHNavigationController *navVc = [[YHNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navVc animated:YES completion:nil];
    }
    
}





//发送按钮点击
- (void)rightBtnClick {
    
    
    self.sendBtn.userInteractionEnabled = NO;
    
    if ([YHUserInfo shareInstance].isLogin) {  // 是否登录
        //发送评论请求
        [self sendCommentRequest];
    } else {  // 没登录  跳转到登录页面
        
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.loginOrReg = YES;
        YHNavigationController *navVc = [[YHNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navVc animated:YES completion:nil];
    }
    
}



#pragma mark - 设置导航栏
- (void)setNav {
    // 自定义标题
    self.title = @"详情内容";
}

#pragma mark - 请求数据

//获得发现详情
- (void)getDetailsData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1073" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.ID] forKey:@"rec_id"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [self showLoadingView];
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        //关闭加载
        [self hidenLoadingView];
        
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            
            _foundDetailsModel = [FoundDetailsModel mj_objectWithKeyValues:result];
            
            [self.tableView reloadData];
            
            //0待审核 1审核通过 2审核不通过
            if ([_foundDetailsModel.ndStatus isEqualToString:@"0"]) {
                [self showMessage:@"发现还在审核中，暂未有评论" delay:1];
                self.bottomView.userInteractionEnabled = NO;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }else if([_foundDetailsModel.ndStatus isEqualToString:@"1"]) {
                //得到评论数据
                [self getCommentData];
            }else if([_foundDetailsModel.ndStatus isEqualToString:@"2"]) {
                [self showMessage:@"发现审核未通过" delay:1];
                self.bottomView.userInteractionEnabled = NO;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            
        }else {
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        return YES;
    }];
    
}

//获得评论列表
- (void)getCommentData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1075" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.ID] forKey:@"rec_id"];
    [dictParam setValue:@"1" forKey:@"rec_pageIndex"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            self.pageIndex = 1;
            _foundCommentsModel = [FoundCommentsModel mj_objectWithKeyValues:result];
            
            _commentDataArray = [NSMutableArray arrayWithArray:_foundCommentsModel.dataList];
            self.pageIndex++;
            
            // 刷新表格
            [self.tableView reloadData];
            
        }else {
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
        }
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        
        
        return YES;
    }];
    
    
}
//发送评论请求
- (void)sendCommentRequest {
    
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1074" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.ID] forKey:@"rec_id"];
    [dictParam setValue:self.bottomTextView.text forKey:@"rec_content"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        self.sendBtn.userInteractionEnabled = YES;
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            
            
            _bottomTextView.text = @"";
            [self.bottomTextView resignFirstResponder];
            
            [UIView animateWithDuration:0.25 animations:^{
                
                [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(kBottomHeight);
                }];
                
                [self.bottomTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(34);
                }];
                
                [self.view layoutIfNeeded];
            }];
            
            //重新获取评论数据
            self.foundDetailsModel.commentNum++;
            [self getCommentData];
            //设置发现按钮状态
            [self.sendBtn setBackgroundColor:[UIColor colorWithRed:0.914  green:0.918  blue:0.922 alpha:1]];
            [self.sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            self.sendBtn.enabled = NO;
            
        }else {
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
        }
        
        
        
        return YES;
    }];
    
    
    
}

//发送点赞请求
- (void)sendUpvoteRequest {
    
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1076" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.ID] forKey:@"rec_id"];
    
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:2];
            //点赞成功更新ui
            self.upvoteBtn.selected = !self.upvoteBtn.selected;
            
        }else {
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:2];
        }
        
        
        
        return YES;
    }];
    
}

//删除发现评论请求
- (void)sendDeleteSquareCommentRequestWithModel:(FoundCommentModel *)model withBtn:(UIButton *)btn{
    
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1079" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:model.cmID.stringValue forKey:@"rec_id"]; // 评论ID
    
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@",result);
        
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            
            
            //删除成功 更新请求
            [self.commentDataArray removeObject:model];
            [self.tableView reloadData];
            self.foundDetailsModel.commentNum--;
            
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:2];
            
        }else {
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:2];
        }
        
        
        
        return YES;
    }];
    
    
    
    
    
}





#pragma mark - UITableViewDelegate - 子类重写
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section == 0) {
        return 1;
    }else{
        return self.commentDataArray.count;
    }
    
}

//动态计算高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _foundDetailsModel.cellHeight ? _foundDetailsModel.cellHeight : 200;
    }
    FoundCommentModel *model = self.commentDataArray[indexPath.row];
    
    return model.cellHeight;
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = nil;
    
    if (indexPath.section == 0) {
        
        if (_foundDetailsModel.dataList.count == 0) {
            
            static NSString *cellID = @"FoundSquareNoIconCommentCell";
            FoundSquareNoIconCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [FoundSquareNoIconCommentCell cellWithTableView:tableView];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dataModel = self.foundDetailsModel;
            cell.deleteBtn.hidden = YES;
            cell.upvoteNumBtn.hidden = YES;
            cell.commentNumBtn.hidden = YES;
            return cell;
            
        }else {
            
            static NSString *cellID = @"FoundSquareCommentCell";
            FoundSquareCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [FoundSquareCommentCell cellWithTableView:tableView];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dataModel = self.foundDetailsModel;
            cell.delegate = self;
            cell.deleteBtn.hidden = YES;
            cell.upvoteNumBtn.hidden = YES;
            cell.commentNumBtn.hidden = YES;
            
            return cell;
        }
        
        
        
        
    }else if(indexPath.section == 1){
        
        FoundDetailsCommentCell *cell = [FoundDetailsCommentCell cellWithTableView:tableView];
        
        cell.model = self.commentDataArray[indexPath.row];
        cell.delegate = self;
        
        if (cell.model.isMyComment) {
            cell.deleteBtn.hidden = NO;
        }else{
            cell.deleteBtn.hidden = YES;
        }
        
        return cell;
        
    }
    
    
    //返回空CELL
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    //
    if (section == 1 ) {
        return 40;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }
    return 15;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *lineView = [[UIView alloc] init];
    lineView.alpha = 0.3;
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.frame = CGRectMake(0, 0, kUIScreenWidth, 15);
    
    return lineView;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, kUIScreenWidth, 40);
    
    //image
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"Found_square_message"];
    [headerView addSubview:iconView];
    
    //lable
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = [NSString stringWithFormat:@"评论(%d)",self.foundDetailsModel.commentNum];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:titleLabel];
    
    //分隔线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.3;
    [headerView addSubview:line];
    
    //分隔线
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor lightGrayColor];
    line2.alpha = 0.3;
    [headerView addSubview:line2];
    
    
    //添加约束
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerView.mas_centerY);
        make.left.mas_equalTo(headerView.mas_left).offset(12);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerView.mas_centerY);
        make.left.mas_equalTo(iconView.mas_right).offset(10);
        
    }];
    
    //分隔线
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left);
        make.right.mas_equalTo(headerView.mas_right);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(headerView.mas_bottom);
        
    }];
    
    //分隔线
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left);
        make.right.mas_equalTo(headerView.mas_right);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(headerView.mas_top).offset(-1);
        
    }];
    
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    
    if (indexPath.section == 1) {
        
        FoundCommentModel *model = _commentDataArray[indexPath.row];
        
        if(!model.isMyComment){
            
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:@"回复"];
            
            NSAttributedString * str = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",model.Nick] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.561  green:0.769  blue:0.122 alpha:1]}];
            
            [attributedStr appendAttributedString:str];
            
            NSAttributedString * str2 = [[NSAttributedString alloc] initWithString:@"："];
            [attributedStr appendAttributedString:str2];
            
            [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, attributedStr.length)];
            
            
            self.bottomTextView.attributedText = attributedStr;
            //        self.bottomTextView.placeholder = nil;
        }
        
    }
    
    
}

#pragma mark - FoundDetailsCommentCellDelegate 删除评论

- (void)FoundDetailsCommentCellDidClickDeleteBtn:(FoundDetailsCommentCell *)cell
{
    
    //发送删除请求
    [self sendDeleteSquareCommentRequestWithModel:cell.model withBtn:cell.deleteBtn];
    
    
}



#pragma mark - FoundDetailsHeadCellDelegate

- (void)foundSquareCommentCellCell:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imagArray:(NSArray *)imagArray{
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    
    // 分割 截取字符串  如果没有图片=0
    //    CarCommentModel *model = imagArray[indexPath.row];
    //    self.commentImagArray2 = [model.imageUrls componentsSeparatedByString:@","];
    
    self.imageArray = imagArray;
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

#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section {
    return self.imageArray.count;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath {
    
    id imageObj = [self.imageArray objectAtIndex:indexPath.item];
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
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
