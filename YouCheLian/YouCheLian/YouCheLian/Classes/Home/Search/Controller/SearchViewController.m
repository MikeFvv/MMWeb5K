//
//  SearchViewController.m
//  YouCheLian
//
//  Created by Mike on 16/3/2.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchHistoryTableViewCell.h"
#import "SearchShopCell.h"
#import "SearchModels.h"
#import "SearchGoodModels.h"
#import "SCTitleButton.h"
#import "YHLocationManager.h"
#import "SearchLeftGoodCell.h"
#import "SearchRightGoodCell.h"
#import "CarJointDetailsController.h"
#import "FoundCarDetailsViewController.h"
#import "ShopDetailsTableController.h"

#define ReleaseShopHisrtoryStr @"ReleaseHisrtoryStr"


typedef enum : NSUInteger {
    ReleaseStateShop,
    ReleaseStateGood,
} ReleaseState;

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate, CAAnimationDelegate>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UICollectionView *collectionView;
/**数据源*/
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *collectionDataArray;

@property (nonatomic, strong) NSMutableArray *releaseHistoryArray;
//导航栏
@property (nonatomic, strong) UIView *navView;
//清除历史数据按钮
@property (nonatomic, strong) UIButton *clearHistoryBtn;
//切换按钮
@property (nonatomic, strong) SCTitleButton *typeBtn;

@property (nonatomic, strong) UIView *searchView;

@property (nonatomic, strong) UISearchBar *searchBar;

//当前搜索状态
@property (nonatomic, assign) ReleaseState releaseState;

@property (nonatomic, strong) SearchModels *searchModels;

@property (nonatomic, strong) SearchGoodModels *searchGoodModels;

//刷新下标
@property (nonatomic, assign) int pageIndex;

//搜索关键字
@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, strong) CALayer *topLayer;

@property (nonatomic, strong) CALayer *layer;

@property (nonatomic, strong) UILabel *tempLabel;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self initNav];
    
    //创建视图
    [self initView];
    
    
    //注册Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchHistoryTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchShopCell" bundle:nil] forCellReuseIdentifier:@"SearchShopCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchLeftGoodCell" bundle:nil] forCellWithReuseIdentifier:@"SearchLeftGoodCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchRightGoodCell" bundle:nil] forCellWithReuseIdentifier:@"SearchRightGoodCell"];
    
    
    //设置初始搜索状态
    self.releaseState = ReleaseStateShop;
    
    
    self.pageIndex = 1;
    
    //读取历史搜索信息
    self.dataArray = self.releaseHistoryArray;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter && getter
- (NSMutableArray *)dataArray
{
    if (! _dataArray ) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
//获得历史搜索记录，然后在是ViewWillappear中赋值，防止反复读取；
- (NSMutableArray *)releaseHistoryArray{
    if (! _releaseHistoryArray) {
        
        _releaseHistoryArray = [NSMutableArray arrayWithArray:[UserDefaultsTools arrayForKey:ReleaseShopHisrtoryStr]];
        
    }
    return _releaseHistoryArray;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        //流水布局参数
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((kUIScreenWidth - 10 - 16 -16) / 2, 244);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(16, 16, 0, 16);
        
        //添加collection视图
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.hidden = YES;
        _collectionView.backgroundColor = [UIColor colorWithRed:0.953  green:0.957  blue:0.961 alpha:1];
        
    }
    return _collectionView;
}

#pragma mark - 初始化视图
- (void)initView{
    
    
    //初始化tableView
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        
    }];
    
    //设置上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadShopNewData)];
    
    
    self.tableView.mj_footer.hidden = YES;
    
    //初始化collectView(懒加载)
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        
    }];
    //collectionView的上拉刷新
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadGoodNewData)];
    
    //    self.tableView.mj_footer.hidden = YES;
    
    
    //清空历史数据按钮
    UIButton *clearHistoryBtn = [[UIButton alloc] init];
    if (self.releaseHistoryArray.count == 0) {
        clearHistoryBtn.hidden = YES;
    }
    
    clearHistoryBtn.layer.cornerRadius = 18;
    clearHistoryBtn.layer.borderWidth = 1;
    clearHistoryBtn.layer.borderColor = [UIColor colorWithRed:0.588  green:0.776  blue:0.145 alpha:1].CGColor;
    [clearHistoryBtn setTitle:@"清空历史搜索" forState:UIControlStateNormal];
    [clearHistoryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [clearHistoryBtn setTitleColor:[UIColor colorWithRed:0.588  green:0.776  blue:0.145 alpha:1] forState:UIControlStateHighlighted];
    [clearHistoryBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:clearHistoryBtn];
    self.clearHistoryBtn  = clearHistoryBtn;
    
    [clearHistoryBtn addTarget:self action:@selector(clearHistoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [clearHistoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
        make.width.mas_equalTo(kUIScreenWidth / 2.2 );
        make.height.mas_equalTo(36);
    }];
    
}


#pragma mark - 设置导航栏
- (void)initNav{
    
    self.navigationController.navigationBar.hidden = YES;
    
    //导航栏视图
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    self.navView = navView;
    
    //工具栏
    UIView *toolView  = [[UIView alloc] init];
    [navView addSubview:toolView];
    
    // 为返回 View
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [toolView addSubview:backView];
    
    // 为返回按钮 添加手势
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackBtn)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [backView addGestureRecognizer:gesture];
    
    
    // Nav 返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 返回按钮内容左靠
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn setImage:[UIImage imageNamed:@"Search_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    
    
    
    // 搜索
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [searchBtn setTitleColor:[UIColor colorWithRed:0.588  green:0.776  blue:0.145 alpha:1] forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(onSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:searchBtn];
    
    //中间的视图
    UIView *searchView = [[UIView alloc] init];
    searchView.layer.cornerRadius = (44 - 7 - 7) / 2;
    searchView.layer.borderWidth = 1;
    searchView.layer.borderColor = [UIColor colorWithRed:0.588  green:0.776  blue:0.145 alpha:1].CGColor;
    [toolView addSubview:searchView];
    self.searchView = searchView;
    
    //左边的商品按钮
    // 城市显示及 图标
    SCTitleButton *typeBtn = [[SCTitleButton alloc] init];
    // 图标是否在button 右边
    typeBtn.moveImageToRight = YES;
    typeBtn.frame = CGRectMake(0, 0, 80, 25);
    
    [typeBtn setImage:[UIImage imageNamed:@"Search_down2"] forState:UIControlStateNormal];
    [typeBtn setImage:[UIImage imageNamed:@"Search_down2"] forState:UIControlStateHighlighted];
    [typeBtn setTitle:@"商家" forState:UIControlStateNormal];
    
    typeBtn.titleFont = YHFont(15, NO);;
    // 设置Nav LeftBtn 字体颜色
    typeBtn.titleColor = [UIColor darkGrayColor];
    [typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:typeBtn];
    self.typeBtn = typeBtn;
    
    //动画视图
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索";
    [searchBar setImage:[UIImage imageNamed:@"Search_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchView addSubview:searchBar];
    self.searchBar = searchBar;
    
    //分隔线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.3;
    [searchView addSubview:line];
    
    //去掉周围的黑边
    if ([self.searchBar respondsToSelector:@selector(barTintColor)]) {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.1) {
            //ios7.1
            [[[[self.searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [self.searchBar setBackgroundColor:[UIColor clearColor]];
        }else{
            //ios7.0
            [self.searchBar setBarTintColor:[UIColor clearColor]];
            [self.searchBar setBackgroundColor:[UIColor clearColor]];
        }
    }else{
        //iOS7.0 以下
        [[self.searchBar.subviews objectAtIndex:0] removeFromSuperview];
        [self.searchBar setBackgroundColor:[UIColor clearColor]];
    }
    
    //分隔线2
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor lightGrayColor];
    line2.alpha = 0.3;
    [navView addSubview:line2];
    
    //设置约束
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(64);
        
    }];
    
    //工具栏
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(navView.mas_bottom);
        make.left.mas_equalTo(navView.mas_left);
        make.right.mas_equalTo(navView.mas_right);
        make.height.mas_equalTo(44);
        
    }];
    
    
    // 返回View
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(toolView.centerY);
        make.left.mas_equalTo(toolView.mas_left).offset(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(40);
        
    }];
    //返回按钮
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(backView.centerY);
        make.left.mas_equalTo(backView.mas_left).offset(10);
        
        //        make.centerY.mas_equalTo(toolView.centerY);
        //        make.left.mas_equalTo(toolView.mas_left).offset(15);
        
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(11);
        
    }];
    
    
    
    //搜索按钮
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(toolView.mas_centerY);
        make.right.mas_equalTo(toolView.mas_right).offset(-10);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
        
    }];
    
    //搜索栏
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backBtn.mas_right).offset(25);
        make.right.mas_equalTo(searchBtn.mas_left).offset(-10);
        make.top.mas_equalTo(toolView.mas_top).offset(7);
        make.bottom.mas_equalTo(toolView.mas_bottom).offset(-7);
    }];
    
    //商家按钮
    [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(searchView.mas_centerY);
        make.left.mas_equalTo(searchView.mas_left).offset(15);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
        
    }];
    
    //分隔线
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(searchView.mas_centerY);
        make.left.mas_equalTo(typeBtn.mas_right).offset(10);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(searchView.mas_height).multipliedBy(0.5);
        
    }];
    
    //searchBar
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line.mas_right).offset(-10);
        make.right.mas_equalTo(searchView.mas_right).offset(10);
        make.top.mas_equalTo(searchView.mas_top);
        make.bottom.mas_equalTo(searchView.mas_bottom);
    }];
    
    //分隔线
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(navView.mas_left);
        make.right.mas_equalTo(navView.mas_right);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(navView.mas_bottom);
        
    }];
    
}



#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self onSearchBtn];
}

#pragma mark - 搜索按钮点击
- (void)onSearchBtn {
    [self.searchBar resignFirstResponder];
    
    //滚动到第一行
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    //保存搜索关键字 用于上拉刷新
    
    self.searchText = self.searchBar.text;
    
    //添加到搜索历史中
    if(self.searchBar.text != nil && ![self.searchBar.text isEqualToString:@""]){
        
        [self.tableView.mj_footer resetNoMoreData];
        [self.collectionView.mj_footer resetNoMoreData];
        
        for (int i = 0; i < _releaseHistoryArray.count;i++) {
            
            NSString *str = _releaseHistoryArray[i];
            
            if ([str isEqualToString:self.searchBar.text]) {
                
                [_releaseHistoryArray insertObject:str atIndex:0];
                [_releaseHistoryArray removeObjectAtIndex:i + 1];
                
            }
        }
        
        if (_releaseHistoryArray.count == 0) {
            
            [self.releaseHistoryArray addObject:self.searchBar.text];
            
        }else if (![_releaseHistoryArray[0] isEqualToString:self.searchBar.text]) {
            
            [self.releaseHistoryArray insertObject:self.searchBar.text atIndex:0];
            
        }
        
        //保存历史搜索信息
        [UserDefaultsTools setObject:self.releaseHistoryArray forKey:ReleaseShopHisrtoryStr];
        
        if (self.releaseState == ReleaseStateShop) {
            
            //发送搜索请求
            [self getSearchShopData];
        }else if (self.releaseState == ReleaseStateGood) {
            //            self.collectionView.hidden = NO;
            //            self.tableView.hidden = YES;
            //发送搜索请求
            [self getSearchGoodData];
        }
        
        
    }
    
    
}

- (void)onBackBtn {
    // 在push控制器时显示UITabBar
    self.tabBarController.tabBar.hidden = NO;
    // 将栈顶的控制器移除
    [self.navigationController popViewControllerAnimated:YES];
}

//商家按钮点击
- (void)typeBtnClick:(UIButton *)sender {
    
    self.typeBtn.userInteractionEnabled = NO;
    
    self.tableView.mj_footer.hidden = YES;
    
    if (self.releaseState == ReleaseStateShop) {
        
        self.releaseState = ReleaseStateGood;
        
    }else{
        
        self.releaseState = ReleaseStateShop;
        
    }
    
    [self buttonAnimation];
    
    //点击商家按钮显示历史搜索界面
    self.collectionView.hidden = YES;
    self.tableView.hidden = NO;
    
    //读取搜索历史
    _releaseHistoryArray = [NSMutableArray arrayWithArray:[UserDefaultsTools arrayForKey:ReleaseShopHisrtoryStr]];
    self.dataArray = _releaseHistoryArray;
    
    [self.tableView reloadData];
    
}

//动画效果

- (void)buttonAnimation {
    
    UILabel *label =  [[UILabel alloc] init];
    label.frame = self.typeBtn.frame;
    if (self.releaseState == ReleaseStateGood) {
        label.text = @"商品";
    }else{
        label.text = @"商家";
        
    }
    
    label.font = self.typeBtn.titleLabel.font;
    label.textColor = self.typeBtn.titleLabel.textColor;
    [self.searchView addSubview:label];
    self.tempLabel = label;
    
    
    CALayer *toplayer = label.layer;
    self.topLayer = toplayer;
    CABasicAnimation *topAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    topAnimation.delegate = self;
    topAnimation.duration = 0.5;
    topAnimation.repeatCount = 0;
    topAnimation.removedOnCompletion = NO;
    topAnimation.fillMode = kCAFillModeRemoved;
    topAnimation.autoreverses = NO;
    topAnimation.fromValue = [NSNumber numberWithFloat:-10];
    topAnimation.toValue = [NSNumber numberWithFloat:0];
    [toplayer addAnimation:topAnimation forKey:@"animateLayer"];
    
    
    CALayer *layer = self.typeBtn.titleLabel.layer;
    self.layer = layer;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.delegate = self;
    animation.duration = 0.5;
    animation.repeatCount = 0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:30];
    [layer addAnimation:animation forKey:@"animateLayer"];
    
}

#pragma mark - 动画结束回调代理方法

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    self.typeBtn.userInteractionEnabled = YES;
    [self.tempLabel removeFromSuperview];
    [self.topLayer removeAnimationForKey:@"animateLayer"];
    [self.layer removeAnimationForKey:@"animateLayer"];
    
    if (self.releaseState == ReleaseStateGood) {
        
        
        [self.typeBtn setTitle:@"商品" forState:UIControlStateNormal];
        
    }else{
        
        
        [self.typeBtn setTitle:@"商家" forState:UIControlStateNormal];
        
        
    }
    
}




//清除历史数据按钮点击
- (void)clearHistoryBtnClick{
    self.releaseHistoryArray = [NSMutableArray array];
    self.dataArray = nil;
    self.clearHistoryBtn.hidden = YES;
    
    [UserDefaultsTools setObject:self.releaseHistoryArray forKey:ReleaseShopHisrtoryStr];
    
    [self.tableView reloadData];
    
    
}

#pragma mark - 发送搜索请求
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
    [dictParam setValue:self.searchBar.text forKey:@"rec_key"];
    [dictParam setValue:@"0" forKey:@"rec_distince"];
    [dictParam setValue:@"0" forKey:@"res_filter"];
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            _searchModels = [SearchModels mj_objectWithKeyValues:result];
            
            self.dataArray = [NSMutableArray arrayWithArray:_searchModels.dataList];
            
            //显示下拉刷新和重置刷新状态
            self.tableView.mj_footer.hidden = NO;
            
        }else {
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            
            self.dataArray = _releaseHistoryArray;
            
        }
        // 刷新表格
        [self.tableView reloadData];
        
        return YES;
    }];
}

///搜索商品请求
- (void)getSearchGoodData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1024" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:@"" forKey:@"rec_id"];
    [dictParam setValue:@"1" forKey:@"rec_pageIndex"];
    [dictParam setValue:@"10" forKey:@"rec_pageSize"];
    [dictParam setValue:self.searchBar.text forKey:@"rec_key"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            _searchGoodModels = [SearchGoodModels mj_objectWithKeyValues:result];
            if (_searchGoodModels.dataList.count != 0) {
                self.collectionDataArray = [NSMutableArray arrayWithArray:_searchGoodModels.dataList];
            }
            
        }else {
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            
        }
        
        // 刷新表格
        [self.tableView reloadData];
        [self.collectionView reloadData];
        
        
        if (_searchGoodModels.dataList.count == 0) {
            
            [self showMessage:@"没有数据" delay:1];
            
            //没有数据显示历史搜索界面
            //            self.collectionView.hidden = YES;
            //            self.tableView.hidden = NO;
            //            //隐藏清空按钮
            //            self.clearHistoryBtn.hidden = NO;
            
        }else{//有数据展示界面
            self.collectionView.hidden = NO;
            self.tableView.hidden = YES;
            
        }
        //隐藏清空按钮
        self.clearHistoryBtn.hidden = YES;
        
        
        
        return YES;
    }];
}

//上拉刷新请求
- (void)loadShopNewData {
    
    self.pageIndex++;
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1011" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:@"1" forKey:@"rec_sysId"];
    //获得自己当前百度坐标
    CLLocationCoordinate2D coord = [[YHLocationManager shareInstance] BDlocation];
    [dictParam setValue:[NSString stringWithFormat:@"%f",coord.latitude] forKey:@"rec_lat"];
    [dictParam setValue:[NSString stringWithFormat:@"%f",coord.longitude] forKey:@"rec_lng"];
    [dictParam setValue:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"rec_pageIndex"];
    [dictParam setValue:@"10" forKey:@"rec_pageSize"];
    [dictParam setValue:@"0" forKey:@"rec_merchType"];
    [dictParam setValue:@"0" forKey:@"rec_type"];
    [dictParam setValue:self.searchText forKey:@"rec_key"];
    [dictParam setValue:@"0" forKey:@"rec_distince"];
    [dictParam setValue:@"0" forKey:@"res_filter"];
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            _searchModels = [SearchModels mj_objectWithKeyValues:result];
            [self.dataArray addObjectsFromArray:_searchModels.dataList];
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.pageIndex = 1;
        }
        // 刷新表格
        [self.tableView reloadData];
        
        return YES;
    }];
    
    
}

//上拉刷新请求
- (void)loadGoodNewData {
    
    self.pageIndex++;
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1024" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:@"" forKey:@"rec_id"];
    [dictParam setValue:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"rec_pageIndex"];
    [dictParam setValue:@"10" forKey:@"rec_pageSize"];
    [dictParam setValue:self.searchText forKey:@"rec_key"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            _searchGoodModels = [SearchGoodModels mj_objectWithKeyValues:result];
            
            if (_searchGoodModels.dataList.count != 0) {
                
                [self.collectionDataArray addObjectsFromArray:_searchGoodModels.dataList];
                [self.collectionView.mj_footer endRefreshing];
            }
            
        }else {
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            self.pageIndex = 1;
            
            
        }
        
        // 刷新表格
        [self.tableView reloadData];
        [self.collectionView reloadData];
        
        
        if (_searchGoodModels.dataList.count == 0) {
            
            //            [self showMessage:@"没有数据" delay:1];
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            self.pageIndex = 1;
            
        }else{//有数据展示界面
            self.collectionView.hidden = NO;
            self.tableView.hidden = YES;
            
        }
        //隐藏清空按钮
        self.clearHistoryBtn.hidden = YES;
        
        
        
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
    if (self.releaseHistoryArray == self.dataArray) {
        return 40;
    }
    
    return 155;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = nil;
    
    if (self.dataArray == self.releaseHistoryArray) {
        
        cellID = @"SearchHistoryTableViewCell";
        
        SearchHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        cell.content = self.releaseHistoryArray[indexPath.row];
        
        return cell;
        
    }else if(self.searchModels != nil){
        
        cellID = @"SearchShopCell";
        
        SearchShopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[SearchShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.model = self.dataArray[indexPath.row];
        
        return cell;
        
    }
    //返回空CELL
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.releaseHistoryArray == self.dataArray) {
        
        self.searchBar.text = self.releaseHistoryArray[indexPath.row];
        self.searchText = self.releaseHistoryArray[indexPath.row];
        
        [self onSearchBtn];
        
    }else{//跳转到商家详情界面
        
        SearchModel *model = self.dataArray[indexPath.row];
        // 商家详情
        ShopDetailsTableController *vc = [[ShopDetailsTableController alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        vc.title = model.merchName;
        vc.shopId = model.ID.stringValue;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    //如果有头部就有删除按钮
    if (self.releaseHistoryArray != self.dataArray || self.releaseHistoryArray.count == 0) {
        //隐藏清空按钮
        self.clearHistoryBtn.hidden = YES;
        return 0;
    }else{
        //显示清空按钮
        self.clearHistoryBtn.hidden = NO;
        return 40;
        
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, kUIScreenWidth, 40);
    
    //lable
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"最近搜索";
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
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerView.mas_centerY);
        make.left.mas_equalTo(headerView.mas_left).offset(12);
        
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

#pragma mark - UICollectionViewDataSource代理

//返回元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectionDataArray.count;
    
}


//设置collectionCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *recumeStr = nil;
    if (indexPath.row % 2 == 0) {
        recumeStr = @"SearchLeftGoodCell";
    }else{
        recumeStr = @"SearchRightGoodCell";
    }
    SearchLeftGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:recumeStr forIndexPath:indexPath];
    cell.model = self.collectionDataArray[indexPath.row];
    
    
    return cell;
    
}


//设置组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchGoodModel *model = self.collectionDataArray[indexPath.row];
    
    if ([model.goodType isEqualToString:@"0"]) {//跳转到商品详情界面
        //商品详情
        CarJointDetailsController *vc = [[CarJointDetailsController alloc] init];
        vc.carId = model.ID.stringValue;
        vc.type = @"0";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if([model.goodType isEqualToString:@"1"]) {
        
        //车辆详情
        FoundCarDetailsViewController *vc = [[FoundCarDetailsViewController alloc] init];
        self.tabBarController.tabBar.hidden = YES;
        
        //        MotoListModel *model =  _shopDetailsModel.motolist[index];
        vc.carId = model.ID.stringValue;
        vc.type = @"1";
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
    
    
    
    
    
}


@end
