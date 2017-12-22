//
//  MeCollectionViewController.m
//  YouCheLian
//
//  Created by Mike on 15/11/26.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "MeCollectionViewController.h"
#import "ShopCollcctionController.h"

#import "SegmentTapView.h"
#import "FlipTableView.h"
#import "ShopCollectionModels.h"

#import "GoodsCollectionController.h"
#import "ShopDetailsTableController.h"
#import "CarJointDetailsController.h"

@interface MeCollectionViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate,ShopCollcctionControllerDelegate,GoodsCollectionControllerDelegate>

@property (nonatomic) NSUInteger numberOfTabs;

@property (nonatomic, strong) UIView *noDataView;

@property (nonatomic, strong) ShopCollectionModels *shopCollectionModels;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSMutableArray *tableArray1;
@property (nonatomic, strong) NSMutableArray *tableArray2;
@property (nonatomic, strong) NSMutableArray *tableArray3;


@property (strong, nonatomic) NSMutableArray *controllsArray;
@property (nonatomic, strong) SegmentTapView *segment;
@property (nonatomic, strong) FlipTableView *flipView;

@property (nonatomic, assign) BOOL firstMark;

@end

@implementation MeCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self initView];
    [self initSegment];
    [self initFlipTableView];
    
    self.numberOfTabs = 3;   ///////当设置数量时，去调用setter方法去加载控件
}


- (void)initView {
    
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];  
    
}

-(void)setNav {
    
    // 导航栏颜色
    self.navigationController.navigationBar.barTintColor = kNavColor;
    // 设置title的字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:kNavTitleFont18,
       NSForegroundColorAttributeName:kFontColor}];
}


/**
 *  当控制器的view即将显示的时候调用
 */
- (void)viewWillAppear:(BOOL)animated {
    
    // 显示导航栏
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    //    self.navigationController.navigationBar.hidden = NO;
    
    // 导航栏颜色
    self.navigationController.navigationBar.barTintColor = kNavColor;

    // 设置title的字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:kNavTitleFont18,
       NSForegroundColorAttributeName:kFontColor}];
}


-(void)initSegment{
    
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 44) withDataArray:[NSArray arrayWithObjects:@"收藏的商品",@"收藏的店铺", nil] withFont:16];
    self.segment.lineColor = [UIColor colorWithRed:0.588  green:0.776  blue:0.145 alpha:1];
    self.segment.textSelectedColor = [UIColor blackColor];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
}



-(void)initFlipTableView{
    if (!self.controllsArray) {
        self.controllsArray = [[NSMutableArray alloc] init];
    }
    
    //添加控制器
    GoodsCollectionController *goodVC= [[GoodsCollectionController alloc] init];
    goodVC.delegate = self;
    
    ShopCollcctionController *shopVC= [[ShopCollcctionController alloc] init];
    shopVC.delegate = self;
    
    [self.controllsArray addObject:goodVC];
    [self.controllsArray addObject:shopVC];
    
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 44, kUIScreenWidth, kUIScreenHeight - 64 - 44) withArray:_controllsArray];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
}


#pragma mark -------- select Index
-(void)selectedIndex:(NSInteger)index
{
    NSLog(@"%zd",index);
    [self.flipView selectIndex:index];
    
}
-(void)scrollChangeToIndex:(NSInteger)index
{
    NSLog(@"%zd",index);
    [self.segment selectIndex:index];
}


#pragma mark - 商品 详情跳转
///商品详情跳转
- (void)jumpGoodsDetailsDelegate:(NSString *)goodsId {
    
    //商品详情
    CarJointDetailsController *vc = [[CarJointDetailsController alloc] init];
    vc.carId = goodsId;
    vc.type = @"0";  // 商城传 0
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 商家 详情跳转
///商家详情跳转
- (void)jumpShopDetailsDelegate:(NSString *)shopId {
    
    ShopDetailsTableController *vc = [[ShopDetailsTableController alloc] init];
    vc.shopId = shopId;
    [self.navigationController pushViewController:vc animated:YES];
}


- (UILabel *)createLabel:(NSString *)name {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = [NSString stringWithFormat:name, index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    return label;
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
