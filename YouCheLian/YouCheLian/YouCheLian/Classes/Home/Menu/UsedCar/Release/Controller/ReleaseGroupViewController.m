//
//  ReleaseGroupViewController.m
//  YouCheLian
//
//  Created by Mike on 16/3/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ReleaseGroupViewController.h"
#import "ReleaseGroupModel.h"

@interface ReleaseGroupViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;



@end

@implementation ReleaseGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    [self initView];
    
    self.title = @"分类";

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
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
    
    ReleaseGroupModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(releaseGroupViewControllerWithModel:)]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        ReleaseGroupModel *model = self.dataArray[indexPath.row];
        [self.delegate releaseGroupViewControllerWithModel:model];
    }
    
    
}



@end
