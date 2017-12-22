//
//  ReleaseBrandViewController.m
//  YouCheLian
//
//  Created by Mike on 16/3/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ReleaseBrandViewController.h"
#import "WWPinyinGroup.h"

@interface ReleaseBrandViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;



@property (nonatomic, strong) NSMutableArray *sortedArrForArrays;

@property (nonatomic, strong) NSMutableArray *sectionHeadsKeys;


@end

@implementation ReleaseBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    NSDictionary *dict = [WWPinyinGroup group:self.dataArray key:@"name"];
    _sortedArrForArrays = [dict objectForKey:LEOPinyinGroupResultKey];
    _sectionHeadsKeys = [dict objectForKey:LEOPinyinGroupCharKey];
    [self initView];
    
    self.title = @"品牌";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    //初始化tableView
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sortedArrForArrays.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.sortedArrForArrays[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        //添加分隔线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.3;
        [cell.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.mas_equalTo(cell.contentView.mas_left);
            make.right.mas_equalTo(cell.contentView.mas_right);
            make.bottom.mas_equalTo(cell.contentView.mas_bottom);
        }];
        
    }
    
    ReleaseGroupModel *model = self.sortedArrForArrays[indexPath.section][indexPath.row];
    cell.textLabel.text = model.name;
    
    return cell;
}

// 第section分区的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [_sectionHeadsKeys objectAtIndex:section];
    
}
// 返回每组标题索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.sectionHeadsKeys;
    
}

#pragma mark - UITableViewDelegate代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(ReleaseBrandViewControllerWithModel:)]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        ReleaseGroupModel *model = self.sortedArrForArrays[indexPath.section][indexPath.row];
        [self.delegate ReleaseBrandViewControllerWithModel:model];
    }
    
    
}



@end
