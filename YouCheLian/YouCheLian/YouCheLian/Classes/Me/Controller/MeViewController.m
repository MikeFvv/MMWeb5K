//
//  MeViewController.m
//  YouCheLian
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "MeViewController.h"
#import "MeModel.h"
#import "MeCell.h"
#import "MeHeaderView.h"

#import "LoginViewController.h"
#import "YHNavigationController.h"
#import "GeneralSettingController.h"
#import "SettingController.h"

#import "ProductIntroductionController.h"   // 产品介绍
#import "MeCollectionViewController.h"   // 我的收藏
#import "PersonalInfoController.h"  // 个人资料
#import "MeMessageViewController.h" //我的消息
#import "MeSecondCarViewController.h"//二手车信息

#import "UIImageView+WebCache.h"

#import "UIButton+WebCache.h"
#import "ReceivingAddressController.h"  // 地址管理
#import "MePaymentCell.h"
#import "OrderInfoModel.h"
#import "DefaultWebController.h"
#import "PersonalInfoModel.h"


#define CellFooterheight 70
#define HeadrCardColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]

// 最大请求次数
#define requestCountLimit 6

//#import "WebViewController.h"
@interface MeViewController ()<UITableViewDelegate, UITableViewDataSource,MeHeaderViewDelegate,MePaymentCellDelegate>
{
    UIScrollView * _scrollView;
    NSMutableArray *_myArray;//模型
}
@property (nonatomic, strong) MeHeaderView *meHeaderView;

@property (nonatomic, strong) YHNavigationController *navController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *meModelArray;

@property (nonatomic, strong) UIWebView  *webView;  // 用来打电话跳转的
@property (nonatomic, strong) OrderInfoModel *orderInfoModel;

@property (nonatomic, strong) PersonalInfoModel *personalInfoModel;

@property (nonatomic, assign) NSInteger requestCountMark;

@end

@implementation MeViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self.view addSubview:self.tableView];
    [self initHeadView];
    
    // 注册cell
    [self.tableView registerClass:[MeCell class] forCellReuseIdentifier:@"MeCell"];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    // 显示tabbar
    self.tabBarController.tabBar.hidden = NO;
    
     [self dispatchGroup];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 显示导航栏
    self.navigationController.navigationBarHidden = NO;
}



#pragma mark - 调度组
///  调度组
- (void)dispatchGroup {
    _requestCountMark = 0;
    //  群组－统一监控一组任务
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    
//    [self showLoadingView];
    // 添加任务
    // group 负责监控任务，queue 负责调度任务
    dispatch_group_async(group, q, ^{
        // 用户信息
        [self getUserData];
        NSLog(@"任务1 %@", [NSThread currentThread]);
    });
    //登录时才查询订单信息
    if ([YHUserInfo shareInstance].isLogin) {
        dispatch_group_async(group, q, ^{
            // 订单 等 信息
            [self getOrderInfoAction];
            NSLog(@"任务2 %@", [NSThread currentThread]);
        });
    }
    
    
    // 监听所有任务完成 － 等到 group 中的所有任务执行完毕后，"由队列调度 block 中的任务异步执行！"
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 修改为主队列，后台批量下载，结束后，主线程统一更新UI
//        [self hidenLoadingView];
        NSLog(@"任务OK %@", [NSThread currentThread]);
    });
    NSLog(@"come here");
}




- (void)setNav {
    self.title =@"我的";
    
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = YES;
    
    //更改系统状态栏的颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 20)];
    statusBarView.backgroundColor=[UIColor colorWithRed:0.561  green:0.769  blue:0.122 alpha:1];
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}



#pragma mark - 头部视图
- (void)initHeadView {
    
    self.meHeaderView = [[MeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kMeHeadHeight)];  // 165
    self.meHeaderView.delegate = self;
    
    self.tableView.tableHeaderView = _meHeaderView;
}

// 赋值
-(void)setPersonalInfoModel:(PersonalInfoModel *)personalInfoModel {
    _personalInfoModel = personalInfoModel;
    
    self.meHeaderView.model = personalInfoModel;
}

- (void)setOrderInfoModel:(OrderInfoModel *)orderInfoModel {
    _orderInfoModel = orderInfoModel;
    
    self.meHeaderView.sysmsgneedreadNum = orderInfoModel.sysmsgneedreadNum;
}


/// 下拉放大调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.meHeaderView scrollDidScroll:scrollView];
}


#pragma mark - 初始化 tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kUIScreenWidth ,kUIScreenHeight - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 隐藏分割线
        //        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        //去掉下面没有数据呈现的cell
        _tableView.tableFooterView = [[UIView alloc]init];
        //隐藏滚动条
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    // 滚动条样式
    self.tableView.indicatorStyle =UIScrollViewIndicatorStyleDefault;
    
    // #warning 在viewDidLoad中调用下列方法则不管用
    //分割线对齐屏幕边缘 方法缺一不可
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}








/**
 *  懒加载
 *
 *  @return 就是下声明meModelArray的get方法
 */
-(NSArray *)meModelArray {
    if (_meModelArray == nil) {
        NSArray *mineArray =  [YHFunction arrayWithString:@"Me.plist"];
        NSMutableArray *dictArray = [NSMutableArray array];
        for (NSDictionary *dict  in mineArray) {
            MeModel *model =  [MeModel mineModel:dict];
            [dictArray addObject:model];
        }
        _meModelArray = dictArray;
        
    }
    return _meModelArray;
}



#pragma mark - 请求数据 个人资料
/// 获取个人资料
- (void)getUserData {
    if ([YHUserInfo shareInstance].isLogin == NO) {
        self.personalInfoModel = nil;
        return;
    }
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1022" forKey:@"rec_code"];
    [dictParam setValue: [YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if (error) {
            
            if (self.requestCountMark < requestCountLimit) {
                self.requestCountMark++;
                [self getUserData];
                return NO;
            } else {
//                [self hidenLoadingView];
            }
        } else {
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                YHLog(@"%@", result);
                self.personalInfoModel = [PersonalInfoModel mj_objectWithKeyValues:result];
                
            }else {
                [self showHint:[NSString stringWithFormat:@"%@",result[@"res_desc"]]];
            }
        }
        return YES;
    }];
}



#pragma mark - 获取订单等 信息
/// 获取订单等 信息
- (void)getOrderInfoAction {
    
    if ([YHUserInfo shareInstance].isLogin == NO) {
        self.orderInfoModel = nil;
        return;
    }
    
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1034" forKey:@"rec_code"];
    [dictParam setValue: [YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@", result);
        if (error) {
            YHLog(@"测试");
            if (self.requestCountMark < requestCountLimit) {
                self.requestCountMark++;
                [self getOrderInfoAction];
                return NO;
            } else {
//                [self hidenLoadingView];
            }
        } else {
            
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                
                self.orderInfoModel = [OrderInfoModel mj_objectWithKeyValues:result];
                
                [self.tableView reloadData];
            }
        }
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        //        [self.tableView.mj_header endRefreshing];
        return YES;
    }];
    
    
    
}




#pragma mark - 待支付 / 待收货 / 待评价 / 售后
- (void)onClickViewTagDelegate:(NSInteger)index {
    
    if (![YHUserInfo shareInstance].isLogin) {
        [self jumpGoLogin];
        return;
    }
    
    DefaultWebController * webVC = [[DefaultWebController alloc] init];
    switch (index) {
        case 0:
            
            webVC.urlStr = [YHFunction joDesaccountPassWordUrl: _orderInfoModel.paymentUrl];
            
            break;
        case 1:
            
            webVC.urlStr = [YHFunction joDesaccountPassWordUrl: _orderInfoModel.confirmUrl];
            break;
        case 2:
            
            webVC.urlStr = [YHFunction joDesaccountPassWordUrl: _orderInfoModel.evaluationUrl];
            break;
        case 3:
            [self showHint:@"售后待完善.."];

            return;
            break;
            
        default:
            break;
    }
    
    // 在push控制器时隐藏UITabBar
    [webVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webVC animated:YES];
}


#pragma mark - UITableViewDataSource
/// 一共有多少组数据
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// // 第section分区一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1 + 1;
    }
    return self.meModelArray.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 83;
    }
    return 44;
}

#pragma mark - UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID=@"UITableViewCellIdentifierKey";
    //首先根据标示去缓存池取
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    //如果缓存池没有取到则重新创建并放到缓存池中
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = @"我的订单";
        cell.imageView.image = [UIImage imageNamed:@"me_dingdan"];
        cell.detailTextLabel.text=@"全部订单";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //iOS 7.x 左分割线左对齐到屏幕边缘
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        //iOS 8.x 左分割线左对齐到屏幕边缘
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        // cell右侧显示一个灰色箭头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 1){
        
        MePaymentCell *cell = [MePaymentCell cellWithTableView:tableView];
        cell.model = self.orderInfoModel;
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.section == 1){
        
        MeModel *mineModel = self.meModelArray[indexPath.row];
        // 图片赋值
        MeCell *cella = [MeCell cellWithTableView:tableView meModel:mineModel];
        return cella;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // Cell 选中效果取消
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    id vc = nil;
    UIAlertView *alert;
    if (indexPath.section == 0) {     // 个人信息
        if (indexPath.row == 0) {
            if (![YHUserInfo shareInstance].isLogin) {
                [self jumpGoLogin];
                return;
            }
            // 我的订单 全部订单
            DefaultWebController *webVC = [[DefaultWebController alloc] init];
            webVC.urlStr = [YHFunction joDesaccountPassWordUrl: _orderInfoModel.url];
            // 在push控制器时隐藏UITabBar
            [webVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:webVC animated:YES];
            return;
        }
        return;
    } else {  // 第二组
        // ********* 新增功能 跳转时 请注意这里的判断 *********
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 6) {
            // 切换账号
            if (![YHUserInfo shareInstance].isLogin) {
                [self jumpGoLogin];
                return;
            } else {
                
                
                switch (indexPath.row) {
                    case 0:
                        // 我的优豆
                        [self jumpGoYouDou];
                        return;
                        
                    case 1:
                        
                        // 我的收藏
                        vc = [[MeCollectionViewController  alloc] init];
                        break;
                    case 2:
                        // 二手车信息
                        vc = [[MeSecondCarViewController  alloc] init];
                        
                        break;
                    case 3:
                        // 地址管理
                        vc = [[ReceivingAddressController  alloc] init];
                        
                        break;
                    case 4:
                        // 通用设置
                        vc = [[SettingController  alloc] init];
                        
                        break;
                    case 6:
                        // 切换账号
                        if ([YHUserInfo shareInstance].isLogin) {
                            alert = [[UIAlertView alloc] initWithTitle:@"确定退出登录?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                            [alert show];
                            return;
                        } else {
                            [self jumpGoLogin];
                            return;
                        }
                        break;
                    default:
                        vc = [[ProductIntroductionController alloc] init];
                        break;
                }
            }
        } else {
            
            switch (indexPath.row) {
                case 5:
                    
                    // 联系客服
                    if (_webView == nil) {
                        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
                    }
                    
                    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel://0755-66666888888888"]]];
                    
                    // 关于优车联
//                    vc = [[ProductIntroductionController alloc] init];
                    break;
                    
                case 7:
                    
                    
                    break;
                    
                default:
//                    vc = [[ProductIntroductionController alloc] init];
                    break;
            }
        }
    }
    if (vc != nil) {
        // 在push控制器时隐藏UITabBar
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


/// 跳转到优豆
- (void)jumpGoYouDou {
    
    // 我的优豆
    DefaultWebController *webVC = [[DefaultWebController alloc]init];
    
    NSString *urlStr = [YHFunction joDesaccountPassWordUrl: [[GetUrlString sharedManager] urlYouDou]];
    
    webVC.urlStr = urlStr;
    // 在push控制器时隐藏UITabBar
    [webVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webVC animated:YES];
}




#pragma mark - 退出登录 清除数据

// 退出登录 定义的委托，buttonindex就是按下的按钮的index值
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        // 取消登录选择
    } else {
        
        [self showLoadingView];
        
        UIView *view = [[UIView alloc] init];
        [view removeFromSuperview];
        
        // 删除个人信息
        
        //1 沙盒里
        [YHFunction removeUserInfoPlist];
        //2 UserInfo 模型类
        [YHUserInfo removeUserInfoModel];
        // 编好设置
//        [YHFunction removeDefaults];
        
        //清除cookies
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }
        
        [self hidenLoadingView];
        
        
        
        // 清空登录信息 <<<
        [self getUserData];
        [self getOrderInfoAction];
        
        [self showHint:@"已注销登录"];
        
        [self.tableView reloadData];
        
    }
}


-(void)headerTap:(UITapGestureRecognizer *)sender
{
    
}

#pragma mark - 登录 个人信息编辑
- (void)loginOrEditDelegateAction {
    
    if ([YHUserInfo shareInstance].isLogin) {

        PersonalInfoController *perInfoVC = [[PersonalInfoController alloc] init];
        perInfoVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:perInfoVC animated:YES];
    } else {
        
        [self jumpGoLogin];
    }
}

- (void)jumpGoLogin {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.loginOrReg = YES;
    YHNavigationController *loginView = [[YHNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginView animated:YES completion:nil];
}

#pragma mark - 消息 跳转
// 消息
- (void)newsBtnAction {
    
    if ([YHUserInfo shareInstance].isLogin) {
        
        MeMessageViewController *vc = [[MeMessageViewController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        
        [self jumpGoLogin];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//去掉 UItableview header view 黏性(sticky)
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tableView)
//    {
//        CGFloat sectionHeaderHeight = 60; //sectionHeaderHeight
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}

@end






