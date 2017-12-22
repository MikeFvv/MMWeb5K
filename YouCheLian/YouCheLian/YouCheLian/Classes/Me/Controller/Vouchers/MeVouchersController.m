//
//  MeCollectionViewController.m
//  YouCheLian
//
//  Created by Mike on 15/11/26.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "MeVouchersController.h"
#import "ReceiveController.h"
#import "UseController.h"
#import "OverdueController.h"
#import "VouchersDataListModel.h"
#import "VouchersModel.h"
#import <MJExtension.h>



@interface MeVouchersController ()<TabContainerDelegate,TabContainerDataSource>

@property (nonatomic) NSUInteger numberOfTabs;

@property (nonatomic, strong) UIView *noDataView;

@property (nonatomic, copy) NSArray *titleArray;

@property (nonatomic, strong) VouchersModel *vouchersModel;
@property (nonatomic, strong) VouchersDataListModel *dataListModel;

@property (nonatomic, strong) NSArray *modelArray;

@property (nonatomic, strong) NSMutableArray *tableArray1;
@property (nonatomic, strong) NSMutableArray *tableArray2;
@property (nonatomic, strong) NSMutableArray *tableArray3;

@property (nonatomic, strong) ReceiveController *receiveVC;
@property (nonatomic, strong) UseController *useVC;
@property (nonatomic, strong) OverdueController *overdueVC;

@property (nonatomic, assign) BOOL firstMark;



@end

@implementation MeVouchersController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    self.title = @"商家代金券";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    _receiveVC = [[ReceiveController alloc] init];
    _receiveVC.dataArray = _tableArray1;
    [self initArray];   // 初始化数组
    self.titleArray = @[@"已领取",@"已使用",@"已过期"];
    self.numberOfTabs = 3;   ///////当设置数量时，去调用setter方法去加载控件
    [self getCollData];
    
    
    
    //    [_shopVC dataArray:_tableArray1];
}

/// 初始化数组
- (void)initArray {
    _tableArray1 = [NSMutableArray array];
    _tableArray2 = [NSMutableArray array];
    _tableArray3 = [NSMutableArray array];
}

/// 获取商家数据
- (void)getCollData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1014" forKey:@"rec_code"];
    [dictParam setValue:@"13751157419" forKey:@"rec_userPhone"];
    [dictParam setValue:@"1" forKey:@"rec_type"];
    [dictParam setValue:@"1" forKey:@"rec_pageIndex"];
    [dictParam setValue:@"5" forKey:@"rec_pageSize"];
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];

    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@", result);
        _vouchersModel = [VouchersModel mj_objectWithKeyValues:result];
        _modelArray = _vouchersModel.dataList;
        
        [self separateArray:_modelArray];
        
        _receiveVC.dataArray= _tableArray1;
        [self.receiveVC.tableView reloadData];
        return YES;
    }];
}

// 分数据 已领取 . 已使用 . 已过期
- (void)separateArray:(NSArray *)array {
    for (int i = 0; i < array.count; i++) {
        VouchersDataListModel *model = array[i];
        if (model.type == 1) {
            [_tableArray1 addObject:model];
        } else if (model.type == 2){
            [_tableArray2 addObject:model];
        } else if (model.type == 3) {
            [_tableArray3 addObject:model];
        }
    }
}


- (void)selectTabWithNumberThree {
    [self selectTabAtIndex:3];
}

- (void)setNumberOfTabs:(NSUInteger)numberOfTabs {
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    // Reload data
    [self reloadData];
}


#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // 屏幕旋转后更新
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

#pragma mark --TabContainerDataSource
-(NSUInteger)numberOfTabsForTabContainer:(TabContainerViewController *)tabContainer {
    return self.numberOfTabs;
}

-(UIView *)tabContainer:(TabContainerViewController *)tabContainer viewForTabAtIndex:(NSUInteger)index {
    //  设置标题
    return [self createLabel:self.titleArray[index]];
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


-(UIViewController *)tabContainer:(TabContainerViewController *)tabContainer contentViewControllerForTabAtIndex:(NSUInteger)index
{
    if (index == 0) {
        _receiveVC.dataArray = _tableArray1;
        return _receiveVC;
    }
    if (index == 1) {
        _useVC = [[UseController alloc] init];
        _useVC.dataArray = _tableArray2;
        return _useVC;
    }
    if (index == 2) {
        _overdueVC = [[OverdueController alloc] init];
        _overdueVC.dataArray = _tableArray3;
        return _overdueVC;
    }
    return nil;
}

#pragma mark --TabContainerDelegate
-(CGFloat)heightForTabInTabContainer:(TabContainerViewController *)tabContainer {
    return 45;
}

-(UIColor *)tabContainer:(TabContainerViewController *)tabContainer colorForComponent:(TabContainerComponent)component withDefault:(UIColor *)color {
    switch (component) {
        case TabContainerIndicator:
            // 滑动view 颜色
            return [UIColor colorWithRed:0.141  green:0.702  blue:0.341 alpha:1];
        case TabContainerTabsView:
            return [[UIColor whiteColor] colorWithAlphaComponent:0.32];
        case TabContainerContent:
            return [[UIColor darkGrayColor] colorWithAlphaComponent:0.32];
        default:
            return color;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
