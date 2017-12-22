//
//  ShopDetailsTableController.m
//  YouCheLian
//
//  Created by Mike on 15/12/10.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "ShopDetailsTableController.h"
#import <MJExtension.h>
#import "ShopDetailsModel.h"
#import "ShopImageCell.h"
#import "PicModels.h"
#import "PicModel.h"
#import "YTImageBrowerController.h"

#import "ZLPhoto.h"


#import "ServiceListModel.h"

#import "ShopIntroducesController.h"
#import "DefaultWebController.h"
#import "JZLocationConverter.h"

#import "LoginViewController.h"
#import "YHNavigationController.h"
#import "FoundCarDetailsViewController.h"
#import "MotoListModel.h"

#import "FoundActivityCell.h"
#import <MapKit/MapKit.h>
#import "FoundCarMoreViewController.h"
#import "ActListModel.h"
#import "NSString+Size.h"
#import "DiscountCarHeadCell.h"
#import "DiscountCarCell.h"

// 底部视图高度
#define bottomViewHeight 50
// 最大请求次数
#define requestCountLimit 4

@interface ShopDetailsTableController ()<DiscountCarCellDelegate,ShopImageCellDelegate,YTImageBrowerControllerDelegate,UITableViewDataSource,UITableViewDelegate,ZLPhotoPickerBrowserViewControllerDelegate>{
    CGFloat angle;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ShopDetailsModel *shopDetailsModel;
@property (nonatomic, strong) ServiceListModel *serviceListModel;

@property (nonatomic, strong) PicModels *picModels;
@property (nonatomic, strong) PicModel *picModel;

@property (nonatomic, strong) NSArray *shopDeArray;

@property (nonatomic, strong) NSArray *motoArray;
@property (nonatomic, strong) NSArray *goodsArray;


@property (nonatomic, assign) NSInteger rowNum;
@property (nonatomic, assign) NSInteger rowNum2;

@property (nonatomic, assign) BOOL isCollectState;

@property (nonatomic, assign) NSInteger RefreshCount;
///  打电话用
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSMutableArray *imgs;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) YTImageBrowerController * acdSC;
@property (nonatomic, strong) NSMutableArray *picUrlArr;
@property (nonatomic, strong) NSArray *urls;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *confiView;

@property (nonatomic, assign) NSInteger collectionNum;

@property (nonatomic, assign) NSInteger requestCountMark;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSArray *actListArray;

@end

@implementation ShopDetailsTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initView];
    [self initBottomView];
    [self.view addSubview:self.tableView];
    
    [self dispatchGroup];
    [self headerRefresh]; // 下拉刷新
    
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)reuseCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"Example1TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}


#pragma mark -  调度组
///  调度组
- (void)dispatchGroup {
    //  群组－统一监控一组任务
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    
    [self showLoadingView];
    // 添加任务
    // group 负责监控任务，queue 负责调度任务
    dispatch_group_async(group, q, ^{
        [NSThread sleepForTimeInterval:1.0];
        // 加载数据
        [self getShopDetailsData];
        NSLog(@"任务1 %@", [NSThread currentThread]);
    });
    dispatch_group_async(group, q, ^{
        // 获取商家相册
        [self getPicData];
        NSLog(@"任务2 %@", [NSThread currentThread]);
    });
    
    // 监听所有任务完成 － 等到 group 中的所有任务执行完毕后，"由队列调度 block 中的任务异步执行！"
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 修改为主队列，后台批量下载，结束后，主线程统一更新UI
        //        self.tableView.hidden = NO;
        
        [self hidenLoadingView];
        NSLog(@"任务OK %@", [NSThread currentThread]);
    });
    
    NSLog(@"come here");
}




#pragma mark - 初始化 tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kUIScreenWidth,kUIScreenHeight - kUINavHeight - bottomViewHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        //去掉下面没有数据呈现的cell
        _tableView.tableFooterView = [[UIView alloc]init];
        //        self.tableView.hidden = YES;
    }
    return _tableView;
}


#pragma mark UITableView + 下拉刷新 默认
- (void)headerRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    self.tableView.mj_header = refreshHeader;
    
    [refreshHeader setTitle:@"优宝君正在刷新中，请主人稍安勿躁 " forState:MJRefreshStateRefreshing];
}



-(void)loadNewData {
    [self getShopDetailsData];
}




#pragma mark - 请求 商家详情数据
/// 获取 商家详情
- (void)getShopDetailsData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1025" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:self.shopId forKey:@"rec_id"]; // 商家Id
    //    [dictParam setValue:self.shopId forKey:@"rec_id"]; // 商家Id
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@", result);
        if (error != nil) {
            
            if (self.requestCountMark < requestCountLimit) {
                self.requestCountMark++;
                [self getShopDetailsData];
                return NO;
            }else {
                [self hidenLoadingView];
            }
            
        } else {
            
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                
                _shopDetailsModel = [ShopDetailsModel mj_objectWithKeyValues:result];
                
                _motoArray = _shopDetailsModel.motolist;
                _goodsArray = _shopDetailsModel.goodslist;
                
                // <<<
                _actListArray = _shopDetailsModel.actList;
                
                // 保存是否收藏过
                BOOL isat = _shopDetailsModel.isattention == 0 ? NO : YES;
                [UserDefaultsTools setBool:isat forKey: ShopColStr];
                
                NSString *collNum = [NSString stringWithFormat:@"%zd", _shopDetailsModel.collectionNum];
                [UserDefaultsTools setObject:collNum forKey:ShopCollNum];
                // 保存收藏数量
                self.collectionNum = _shopDetailsModel.collectionNum;
                // 刷新表格
                [self.tableView reloadData];
                //设置title
                self.title = self.shopDetailsModel.mechName;
            } else {
                // 不成功提示
//                [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            }
        }
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        
        return YES;
    }];
}

#pragma mark - Table view 数据源
// 返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1 + 1 + 1;
}

/// 返回回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1 + _actListArray.count;
    } else if (section == 1) {
        return 2;
    }
    return 1;
}


// 设置每行高度 每一行 不是组
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return kHeadImagHeight + 45;
        }
        
        CGSize size = CGSizeMake(kUIScreenWidth-15*2, 60);
        ActListModel *model = _actListArray[indexPath.row -1];
        CGSize actualSize = [model.title sizeWithContentFont:[UIFont systemFontOfSize:14] limitSize:size];
        
        YHLog(@"%f", actualSize.height);
        return 25 + actualSize.height;
        
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            return 45;
        }
        return _motoArray.count > 0 ? DisCarCellHeight : 0;
    }else if(indexPath.section == 2){
        return 45;
    }else {
        return 0;
    }
}

#pragma mark - UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey";
    // 首先根据标示去缓存池取
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // 如果缓存池没有取到则重新创建并放到缓存池中
    if(cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    };
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ShopImageCell *cell = [ShopImageCell cellWithTableView:tableView];
            cell.model = self.shopDetailsModel;
            cell.iconCount = (int)self.picUrlArr.count;
            cell.delegate = self;
            
            // 判断类型来获取Image
            if (_picUrlArr.count > 0) {
                ZLPhotoPickerBrowserPhoto *photo = self.picUrlArr[indexPath.row];
                photo.toView = cell.imgUrlView;
            }
            return cell;
        }
        // 优惠活动
        FoundActivityCell *cell = [FoundActivityCell cellWithTableView:tableView];
        cell.model = _actListArray[indexPath.row -1];
        return cell;
        
        
    }else if (indexPath.section == 1 ){
        if (indexPath.row == 0) {
            DiscountCarHeadCell *cell = [DiscountCarHeadCell cellWithTableView:tableView];
            return cell;
            
        }
        
        DiscountCarCell *cell = [DiscountCarCell cellWithTableView:tableView];
        cell.delegate = self;
        
        cell.cellArray = _motoArray;
        return cell;
        
    }else if (indexPath.section == 2){
        
        cell.textLabel.text = @"商家介绍";
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.textColor = [UIColor blackColor];
        // cell 右侧显示一个灰色箭头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // cell 选中时状态
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }else {
        return cell;
    }
}

// 第section分区尾部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        return nil;
    }
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 0, kUIScreenWidth, 15);
    lineView.backgroundColor = RGBA(236, 236, 236, 1);
    return lineView;
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row != 0) {
            
            DefaultWebController * webVC = [[DefaultWebController alloc] init];
            ActListModel *model = _actListArray[indexPath.row -1];
            
            webVC.urlStr = [YHFunction getWebUrlWithUrl: model.actUrl];
            [self.navigationController pushViewController:webVC animated:YES];
            
        }
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        
#pragma mark - 优惠车型 更多 跳转
        FoundCarMoreViewController *vc = [[FoundCarMoreViewController alloc] init];
        vc.shopId = self.shopId;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.section == 2) {
        // 商家介绍
        ShopIntroducesController *shopIntrVC = [[ShopIntroducesController alloc] init];
        shopIntrVC.contentStr = _shopDetailsModel.context;  // ^^^ context 不知是不是这个
        [self.navigationController pushViewController:shopIntrVC animated:YES];
        //去除选中效果
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    
    
    
    
}


#pragma mark - 点击图片放大浏览 代理方法
- (void)clickImageView {
    // 点击cell 放大缩小图片
    [self setupPhotoBrowser:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    //    if(self.picUrlArr.count > 0) {  // 如果商家相册没有数据就不做相片放大处理
    //        self.acdSC = [[YTImageBrowerController alloc]initWithDelegate:self Imgs:self.imgs Urls:self.picUrlArr PageIndex:(0)];
    //    }
}

#pragma mark - setupCell click ZLPhotoPickerBrowserViewController
- (void) setupPhotoBrowser:(NSIndexPath *)indexPath{
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 数据源/delegate
    pickerBrowser.delegate = self;
    // 数据源可以不传，传photos数组 photos<里面是ZLPhotoPickerBrowserPhoto>
    YHLog(@"图片2===%@",self.picUrlArr);
    
    pickerBrowser.photos = self.picUrlArr;
    // 是否可以删除照片
    pickerBrowser.editing = NO;
    // 当前选中的值
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser didCurrentPage:(NSUInteger)page{
    
    //    [self.tableView setContentOffset:CGPointMake(0, 95 * page)];
    //    NSLog(@" --- %ld", 95 * page);
    
}

#pragma mark - 获取商家相册
///  获取商家相册 图片url
- (void)getPicData {
    _picUrlArr = [NSMutableArray array];
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1046" forKey:@"rec_code"];
    [dictParam setValue:_shopId forKey:@"rec_id"]; // 商家Id（不能为空）
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@", result);
        if (error) {
            
            if (self.requestCountMark < requestCountLimit) {
                self.requestCountMark++;
                [self getPicData];
                return NO;
            }else {
                [self hidenLoadingView];
            }
            
        }else {
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                _picModels = [PicModels mj_objectWithKeyValues:result];
                for (int i = 0; i< _picModels.dataList.count; i++) {
                    _picModel = _picModels.dataList[i];
                    
                    ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                    photo.photoURL = [NSURL URLWithString:_picModel.imgUrl];
                    [_picUrlArr addObject:photo];
                    YHLog(@"图片===%@",_picUrlArr);
                }
            }else {
                // 不成功提示
//                [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            }
        }
        return YES;
    }];
}

#pragma mark - 实现 收藏 商家 代理
- (void)collectBtnAction:(UIButton *)sender {
    //判断是否登录
    if (![YHUserInfo shareInstance].isLogin) {
        
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.loginOrReg = YES;
        YHNavigationController *navVc = [[YHNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navVc animated:YES completion:nil];
        
    } else {
        //已经登录
        
        _isCollectState = [UserDefaultsTools boolForKey:ShopColStr];
        if (_isCollectState) {
            _isCollectState = NO;
            //取消收藏
            [self setCollectData:@"2"];
        }else{
            _isCollectState = YES;
            //确认收藏
            [self setCollectData:@"1"];
        }
    }
}

#pragma mark - 收藏 取消收藏
/// 收藏 取消收藏
- (void)setCollectData:(NSString *)type {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1026" forKey:@"rec_code"];
    [dictParam setValue: [YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:_shopId forKey:@"rec_id"]; // 商家Id（不能为空）
    [dictParam setValue:type forKey:@"rec_type"]; // 1=收藏；2=取消收藏
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if (error != nil) {
            YHLog(@"%@",error);
        } else {
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                NSString *collNum;
                if ([type isEqualToString:@"1"]) { // 收藏
                    [UserDefaultsTools setBool:YES forKey: ShopColStr];
                    self.collectionNum++;
                    collNum = [NSString stringWithFormat:@"%zd", self.collectionNum];
                    [self showMessage:@"收藏成功" delay:0.5];
                } else if ([type isEqualToString:@"2"]){  // 取消收藏
                    [UserDefaultsTools setBool:NO forKey: ShopColStr];
                    self.collectionNum--;
                    collNum = [NSString stringWithFormat:@"%zd", self.collectionNum];
                    [self showMessage:@"取消收藏成功" delay:0.5];
                }
                [UserDefaultsTools setObject:collNum forKey:ShopCollNum];
                // 刷新表格
                [self.tableView reloadData];
                
            } else {  // 不成功提示
                [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            }
        }
        [self.tableView.mj_header endRefreshing];
        return YES;
    }];
}

#pragma mark - 店铺优惠 商家优惠
// 跳转 店铺优惠 商家优惠
- (void)didViewSelectItemAtIndexPath {
    
    //不需要点击隐藏之
    
}

#pragma mark - 实现 优惠车型 跳转详情
- (void)didSelectedDiscountCarCell:(NSInteger)index {
    
    //车辆详情
    FoundCarDetailsViewController *vc = [[FoundCarDetailsViewController alloc] init];
    self.tabBarController.tabBar.hidden = YES;
    
    MotoListModel *model =  _shopDetailsModel.motolist[index];
    vc.carId = [NSString stringWithFormat:@"%zd",model.carId];
    vc.type = @"1";///   0=商城,1=新车，2=活动车
    
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark - 打电话
// 电话 咨询  打电话
- (void)phoneAction:(UIButton *)sender {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    
    NSString *phoneStr = [NSString stringWithFormat:@"tel://%@", _shopDetailsModel.mobile];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneStr]]];
}


// 地图导航
- (void)mapNavAction:(UIButton *)sender {
    [self goThere];
}

#pragma mark - 导航 代理
// 百度、高德、原生地图 导航
- (void)goThere {
    if(_shopDetailsModel == nil) {
        return;
    }
    
    
    
    // 获取 百度坐标 当前经纬度
    CLLocationCoordinate2D baiduLoc = [[YHLocationManager shareInstance] BDlocation];
    
    if ([[YHLocationManager shareInstance] isAuthorization]) {
        // 百度地图
        BOOL mapBool1 = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]];
        // 高德地图
        BOOL mapBool2 = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]];
        if (mapBool1 == YES) {   /****** 百度地图 *******/
            NSString *str = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f,|name:我的位置&destination=latlng:%@,%@|name:%@&mode=driving", baiduLoc.latitude,baiduLoc.longitude,_shopDetailsModel.lat,_shopDetailsModel.lng,_shopDetailsModel.mechName];
            str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (str != nil) {
                NSURL *url = [NSURL URLWithString:str];
                if (url != nil) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }else if(mapBool2 == YES){ /****** 高德地图 *******/
            CLLocationCoordinate2D bd09 = CLLocationCoordinate2DMake(_shopDetailsModel.lat.doubleValue, _shopDetailsModel.lng.doubleValue);
            // 转换 百度转火星
            CLLocationCoordinate2D gcj02 = [JZLocationConverter bd09ToGcj02:bd09];
            
            NSString *str = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=摩托在线&backScheme=com.blackit.motuozaixian&poiname=%@&lat=%f&lon=%f&dev=1&style=2",_shopDetailsModel.mechName,gcj02.latitude,gcj02.longitude];
            str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (str != nil) {
                NSURL *url = [NSURL URLWithString:str];
                if (url != nil) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        } else if(mapBool1 != YES && mapBool2 != YES){ /****** ios原生地图 *******/
            
            CLLocationCoordinate2D bd09 = CLLocationCoordinate2DMake(_shopDetailsModel.lat.doubleValue, _shopDetailsModel.lng.doubleValue);
            // 转换 百度转火星     -- 注意：经测试原生地图 也是用的 中国坐标
            CLLocationCoordinate2D EndCoor = [JZLocationConverter bd09ToGcj02:bd09];
            
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:EndCoor addressDictionary:nil]];
            toLocation.name = _shopDetailsModel.mechName;
            
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        } else {
            [self showErrorMessage:@"没有找到可导航的地图应用"];
        }
    } else {
        [self showErrorMessage:@"获取定位失败,请稍候重试"];
        //            [[LocationManager instance] startUpdatingLocation:nil];
    }
}


#pragma mark - 创建底部视图
- (void)initBottomView {
    
    CGFloat btnHeight = 32;
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kUIScreenHeight - kUINavHeight - bottomViewHeight, kUIScreenWidth, bottomViewHeight)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBA(236, 236, 236, 1);
    [_bottomView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_top);
        make.left.equalTo(_bottomView.mas_left);
        make.right.equalTo(_bottomView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.layer.cornerRadius = btnHeight/2;
    leftBtn.backgroundColor = [UIColor colorWithRed:0.561  green:0.765  blue:0.125 alpha:1];
    [leftBtn addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.titleLabel.font = YHFont(16, NO);;
    [leftBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
    [_bottomView addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.layer.cornerRadius = btnHeight/2;
    rightBtn.backgroundColor = [UIColor colorWithRed:0.561  green:0.765  blue:0.125 alpha:1];
    
    [rightBtn addTarget:self action:@selector(mapNavAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = YHFont(16, NO);;
    [rightBtn setTitle:@"导 航" forState:UIControlStateNormal];
    [_bottomView addSubview:rightBtn];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bottomView.mas_centerX).multipliedBy(0.5);
        make.centerY.mas_equalTo(_bottomView.mas_centerY);
        //        make.left.equalTo(_bottomView.mas_left).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(kUIScreenWidth * 0.32, btnHeight));
    }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.centerX.mas_equalTo(_bottomView.mas_centerX).multipliedBy(1.5);
        
        make.height.mas_equalTo(leftBtn.mas_height);
        make.width.mas_equalTo(leftBtn.mas_width);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
