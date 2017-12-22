//
//  ViewController.m
//  JSDropDownMenuDemo
//
//  Created by Jsfu on 15-1-12.
//  Copyright (c) 2015年 jsfu. All rights reserved.
//

#import "UsedCarController.h"
#import "JSDropDownMenu.h"

#import <MJExtension.h>
#import "UsedCarModels.h"
#import "UsedCarModel.h"

#import "UsedCarCell.h"
#import "UsedCarDetailsController.h"

#import "MyModel.h"

#import "PopUpSelectView.h"
#import "ReleaseViewController.h"

#import "LoginViewController.h"
#import "YHNavigationController.h"


@interface UsedCarController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource, PopUpSelectViewDelegate> {
    
    NSMutableArray *_dataArr0;
    NSArray *_dataArr3;
    NSArray *dataArrPar3;
    
    PopUpSelectView *alertView;   // 弹框
    
    NSInteger _currentData0Index;
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    NSInteger _currentData1SelectedIndex;
    JSDropDownMenu *menu;
    
    
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UsedCarModels *usedCarModels;
@property (nonatomic, strong) UsedCarModel *usedCarModel;

@property (nonatomic, strong) NSMutableArray *usedCarArray;

//@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *sortedArrForArrays;
@property (nonatomic, strong) NSMutableArray *sectionHeadsKeys;

@property (nonatomic, strong) NSArray *brandArrayDict1;
@property (nonatomic, strong) NSArray *brandArrayDict2;
@property (nonatomic, strong) NSMutableArray *allBrandMarrayDict;
@property (nonatomic, strong) NSArray *brandLastArrayDict;

@property (nonatomic, strong) NSMutableArray *classIDMArray; // 最终的id
@property (nonatomic, strong) NSMutableArray *classNameMArray; // 最终的name

@property (nonatomic, copy) NSString *par0;
@property (nonatomic, copy) NSString *par1;
@property (nonatomic, copy) NSString *par2;
@property (nonatomic, copy) NSString *par3;

@property (nonatomic, assign) NSInteger pageIndex;
//上拉刷新数据
@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshFooter;

@end

@implementation UsedCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 指定默认选中
    [self initView];
    [self setNav];
    _currentData1SelectedIndex = 1;
    [self initHeadView];
    [self initAttribute];
    [self.view addSubview:self.tableView];
    
    _usedCarArray = [NSMutableArray array];
    _pageIndex = 1;
    [self getUsedCar];
    
    [self headerRefresh];
    [self footerRefresh];
    [self initPopUpView];
}


- (void)initView {
    self.title = @"二手车";
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"UsedCarCell" bundle:nil] forCellReuseIdentifier:@"UsedCarCell"];
}


- (void)initparameter {
    // 参数初始化
    _par0 = @"0";
    _par1 = @"0";
    _par2 = @"0";
    _par3 = @"0";
    
}

///  初始化属性
- (void)initAttribute {
    _currentData0Index = 0;
    _currentData1Index = 0;
    _currentData2Index = 0;
    _currentData3Index = 0;
}


#pragma mark - 搭建界面
- (void)initPopUpView
{
    alertView = [[PopUpSelectView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight - kUINavHeight)];
    alertView.delegate = self;
}

- (void)initHeadView {
    
    // 摩托车 电动车
    _dataArr0 = [NSMutableArray arrayWithObjects:@"全部", @"摩托车", @"电动车", nil];
    
    // 分类
    _classIDMArray = [NSMutableArray array];
    _classNameMArray = [NSMutableArray array];
    [self getClassArray:@"diandongClass.plist"];
    [self getClassArray:@"motoClass.plist"];
    [_classIDMArray insertObject:@"0" atIndex:0];
    [_classNameMArray insertObject:@"全部" atIndex:0];
    // 品牌
    _brandArrayDict1 = [YHFunction arrayWithString:@"motoBrand.plist"];
    _brandArrayDict2 = [YHFunction arrayWithString:@"carBrand.plist"];
    
    _allBrandMarrayDict = [NSMutableArray arrayWithArray:_brandArrayDict1];
    [_allBrandMarrayDict addObjectsFromArray:_brandArrayDict2];
    _brandLastArrayDict = _allBrandMarrayDict;
    
    // 价格   参数 0  1  2  3  4
    _dataArr3 = @[@"全部", @"1000元以下",@"1000元-2500元",@"2500以上",@"面议"];
    
    
    menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:kHeadTitleHeight];
    menu.JSArrayData = _brandLastArrayDict;  // 品牌特殊处理 先传进去数据
    
    // 箭头
    menu.indicatorColor = [UIColor blackColor];
    // 线条
    menu.separatorColor = kLightGrayColor;
    // 字体
    menu.textColor = [UIColor blackColor];
    menu.dataSource = self;
    menu.delegate = self;
    
    [self.view addSubview:menu];
}



#pragma mark - 初始化 tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kHeadTitleHeight,kUIScreenWidth ,kUIScreenHeight-kHeadTitleHeight -kUINavHeight) style:UITableViewStylePlain];
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


- (void)setNav {
    // Nav 新增
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(onRelease:)];
    
    [addBtn setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                     NSForegroundColorAttributeName:kGlobalColor} forState:UIControlStateNormal
     ];
    self.navigationItem.rightBarButtonItem = addBtn;
    
}


#pragma mark - 发布入口
// 发布入口
- (void)onRelease:(UIButton *)button {
    
    if ([YHUserInfo shareInstance].isLogin) {  // 是否登录
        [alertView showAlertViewWithTitle:@"摩托车信息发布" title2:@"电动车信息发布"];
    } else {  // 没登录  跳转到登录页面
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.loginOrReg = YES;
        YHNavigationController *navVc = [[YHNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navVc animated:YES completion:nil];
    }
}

#pragma mark - 发布 选择 摩托车|电动车 信息发布
- (void)PopUpSelectViewDelegate:(PopUpSelectView *)view index:(NSInteger)index
{
    ReleaseViewController *vc = [[ReleaseViewController alloc] init];
    vc.releaseSuccessBlock = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    
    
    if (index == 0) {
        vc.releaseType = @"10007";
    } else {
        vc.releaseType = @"10008";
    }
    [self.navigationController pushViewController:vc animated:YES];
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
///获取更多数据
- (void)loadMoreUsedData {
    if (self.usedCarArray.count < self.usedCarModels.res_pageTotalSize) {
        self.pageIndex++;
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1040" forKey:@"rec_code"];
    [dictParam setValue:_par0 forKey:@"rec_kind"]; // 商品类别编码（如：摩托车，电动车。《数据字典中的Dic_ID》
    [dictParam setValue:_par1 forKey:@"rec_type"]; // 分类编码(数据字典中的Dic_ID)
    [dictParam setValue:_par2 forKey:@"rec_brand"]; // 品牌(数据字典中的dic_id)
    [dictParam setValue:_par3 forKey:@"rec_price"]; // 价格
    
    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.pageIndex] forKey:@"rec_pageIndex"]; // 第几页,默认值1
    [dictParam setValue:@"10" forKey:@"rec_pageSize"]; // 每页多少条，默认值5
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
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
- (void)getUsedCar {
    
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1040" forKey:@"rec_code"];
    [dictParam setValue:_par0 forKey:@"rec_kind"]; // 商品类别编码（如：摩托车，电动车。《数据字典中的Dic_ID》
    [dictParam setValue:_par1 forKey:@"rec_type"]; // 分类编码(数据字典中的Dic_ID)
    [dictParam setValue:_par2 forKey:@"rec_brand"]; // 品牌(数据字典中的dic_id)
    [dictParam setValue:_par3 forKey:@"rec_price"]; // 价格
    
    [dictParam setValue:@"1" forKey:@"rec_pageIndex"]; // 第几页,默认值1
    [dictParam setValue:@"10" forKey:@"rec_pageSize"]; // 每页多少条，默认值5
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
            _pageIndex = 1;
            _usedCarModels = [UsedCarModels mj_objectWithKeyValues:result];
            
            _usedCarArray = [NSMutableArray arrayWithArray:_usedCarModels.dataList];
            
            //设置上拉刷新默认提示
            if (self.usedCarArray.count == 0) {
                
                [self.refreshFooter setTitle:@"暂时无该类别车辆" forState:MJRefreshStateIdle];
            }else{
                [self.refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
            }
            
        }else {
            [self.refreshFooter setTitle:@"暂时无该类别车辆" forState:MJRefreshStateIdle];
//            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
        }
        
        
        // 刷新表格
        [self.tableView reloadData];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        // 重置上拉刷新提示内容
        [self.tableView.mj_footer resetNoMoreData];
        
        return YES;
    }];
}





- (NSArray *)getClassArray:(NSString *)plist {
    
    // 从文件中加载数组
    NSArray *array = [YHFunction arrayWithString:plist];
    NSMutableArray *mArray = [NSMutableArray array];
    // 添加第一个plist 文件
    for (NSDictionary *dict in array) {
        // 将字典转化模型
        MyModel *model = [MyModel mj_objectWithKeyValues:dict];
        
        [_classIDMArray addObject:model.ID];
        [_classNameMArray addObject:model.name];
    }
    return mArray;
}

#pragma mark - TableView数据源
// 多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 第section分区一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.usedCarArray.count;
}


// 设置每行高度 每一行
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 95;
}

#pragma mark - UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UsedCarCell *cell = [UsedCarCell cellWithTableView:tableView];
    cell.model =  self.usedCarArray[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // Cell 选中效果取消
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UsedCarDetailsController *vc = [[UsedCarDetailsController alloc] init];
    vc.usedCarModel = self.usedCarArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}





#pragma mark - 4个title选项头部代码
// 菜单数量, 默认值为1 // 列数
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    return 4;
}

/**
 * 是否需要显示为UICollectionView 默认为否
 */
-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    return NO;
}

/**
 * 表视图显示时，是否需要两个表显示
 */
-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    return NO;
}

/**
 * 表视图显示时，左边表显示比例
 */
-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    return 1;
}
/**
 * 返回当前菜单左边表选中行  勾选图标
 */
-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        return _currentData0Index;
    }
    if (column==1) {
        return _currentData1Index;
    }
    if (column==2) {
        //        return _currentData2Index;
    }
    if (column==3) {
        return _currentData3Index;
    }
    
    return 0;
}


// 返回数据行数  下拉列表
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        return _dataArr0.count;
    } else if (column==1){
        return _classNameMArray.count;
    } else if (column==2){
        return 100;
    } else if (column==3){
        return _dataArr3.count;
    }
    return 0;
}


// 返回列数  ？  指定默认选中行 title !   第一次进来的默认
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    // 指定默认选中行
    switch (column) {
        case 0: return _dataArr0[_currentData0Index];
            break;
        case 1:
            return @"分类";
            break;
        case 2:
            return @"品牌";
            break;
        case 3:
            return @"价格";
            break;
        default:
            return nil;
            break;
    }
}

// 返回每行title 文字
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    
    if (indexPath.column == 0) {
        return _dataArr0[indexPath.row];
    } else if (indexPath.column==1) {
        return _classNameMArray[indexPath.row];
    }else if (indexPath.column==2) {
        return @"";
    }else {
        if (indexPath.row == 0) {
            return @"全部";
        }
        return _dataArr3[indexPath.row];
    }
}


#pragma mark - 选中行后 返回的 代理
// 当前选中行 代理
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath strID:(NSString *)strID {
    //重置上拉刷新状态
    [self.tableView.mj_footer resetNoMoreData];
    
    if (indexPath.column == 0) {
        [self refreshJSData:indexPath.row];  // 更新品牌列的数据
        [self refreshClassData:indexPath.row];
        
        if (indexPath.row == 1) {
            _par0 = @"10007";
        } else if (indexPath.row == 2) {
            _par0 = @"10008";
        } else {
            _par0 = [NSString stringWithFormat:@"%zd", indexPath.row];
        }
        _currentData0Index = indexPath.row;
    } else if(indexPath.column == 1){
        _currentData1Index = indexPath.row;
        _par1 = _classIDMArray[indexPath.row];
    }else if(indexPath.column == 2){
        _currentData2Index = indexPath.row;
        _par2 = strID;  // 这个是单独为了返回品牌ID增加的参数
    }else if(indexPath.column == 3){
        _par3 = [NSString stringWithFormat:@"%zd", indexPath.row];
        _currentData3Index = indexPath.row;
        
    }
    [_usedCarArray removeAllObjects];
    [self getUsedCar];
}

#pragma mark - 刷新品牌数据
// 刷新品牌数据
- (void)refreshJSData:(NSInteger)index {
    if (index == 0) {
        _brandLastArrayDict = _allBrandMarrayDict;
    }else if (index == 1){
        _brandLastArrayDict = _brandArrayDict1;
    }else if (index == 2) {
        _brandLastArrayDict = _brandArrayDict2;
    }
    menu.JSArrayData = _brandLastArrayDict;
}

// 刷新分类数据
- (void)refreshClassData:(NSInteger)index {
    [_classNameMArray removeAllObjects];
    if (index == 0) {
        [self getClassArray:@"diandongClass.plist"];
        [self getClassArray:@"motoClass.plist"];
    } else if (index == 1) {
        [self getClassArray:@"motoClass.plist"];
    } else {
        [self getClassArray:@"diandongClass.plist"];
    }
    [_classIDMArray insertObject:@"0" atIndex:0];
    [_classNameMArray insertObject:@"全部" atIndex:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end






