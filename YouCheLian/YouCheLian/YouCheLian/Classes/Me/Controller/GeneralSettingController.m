//
//  GeneralSettingController.m
//  YouCheLian
//
//  Created by Mike on 15/11/19.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "GeneralSettingController.h"
#import "MeCell.h"


@interface GeneralSettingController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  组数组(元素类型：SettingGroup)
 */
@property(nonatomic,strong) NSMutableArray *groups;

@end


@implementation GeneralSettingController


- (NSMutableArray *)groups {
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.indicatorStyle =UIScrollViewIndicatorStyleDefault;
    
    //#warning 在viewDidLoad中调用下列方法则不管用
    //分割线对齐屏幕边缘 方法缺一不可
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNav];
    
    [self initTable];
}


- (void)initTable {
    
    //    self.tableView.dataSource = self;
    //    self.tableView.delegate = self;
    // 设置tableView背景颜色
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.tableView.sectionFooterHeight = 15;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 设置分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    // 显示导航栏
    self.navigationController.navigationBarHidden = NO;
}

-(void)setNav {
    self.title = @"通用设置";
    // 设置title的字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:kNavTitleFont18,
       NSForegroundColorAttributeName:kFontColor}];
    
    // Nav 返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = kNav_Back_CGRectMake;
    [backBtn setImage:[UIImage imageNamed:@"Search_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

-(void)onBackBtn:(UIButton *)sender {
    
    // 在push控制器时隐藏UITabBar
    self.hidesBottomBarWhenPushed = NO;
    // 将栈顶的控制器移除
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - tableView 数据源方法
/**
 *  有多少组
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

/**
 * 返回第section组对应的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SettingGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    SettingCell *cell = [SettingCell cellWithTableView:tableView];
    // 获得组模型数据
    SettingGroup *group = self.groups[indexPath.section];
    // 获得item模型数据
    SettingItem *item = group.items[indexPath.row]; // 4 3
    // 传递模型数据
    cell.item = item;
    // 显示或隐藏分割线
    cell.hideLine = (indexPath.row == group.items.count - 1); //
    
    return cell;
}

#pragma mark - tableView 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消cell的选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 根据indexPath获得组模型和item模型
    SettingGroup *group = self.groups[indexPath.section];
    SettingItem *item = group.items[indexPath.row];
    
    
    if ([item isKindOfClass:[SettingItemArrow class]]) { // 箭头
        
        if (indexPath.row == 2) {
            // operationBlock优先级高于下面
            if (item.operationBlock) { //执行block
                item.operationBlock();
                return;
            }
        }
        SettingItemArrow *itemArrow = (SettingItemArrow *)item;
        
        UIStoryboard *strory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // 获得要跳转的控制器名字
        //        UIViewController *destVc = [[itemArrow.destVc alloc] init];
        
        
        UIViewController *destVc = [strory instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"%@", itemArrow.destVc]];

        // 设置标题
        destVc.title = itemArrow.title;
        
        [self.navigationController pushViewController:destVc animated:YES];
    }
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
