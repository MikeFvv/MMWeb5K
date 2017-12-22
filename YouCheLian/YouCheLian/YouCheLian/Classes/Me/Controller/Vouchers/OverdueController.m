//
//  InformationViewController.m
//  YouCheLian
//
//  Created by Mike on 15/11/26.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "OverdueController.h"
#import "OverdueCell.h"
#import "VoucherNoCell.h"

@interface OverdueController ()

@end

@implementation OverdueController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kViewControllerColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArray.count == 0) {
        return 1;
    }
    return self.dataArray.count;
}

// 设置每行高度 每一行 不是组
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return 200;
    }
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataArray.count == 0) {
        VoucherNoCell *cell = [VoucherNoCell cellWithTableView:tableView];
        return cell;
    }
    OverdueCell *cell = [OverdueCell cellWithTableView:tableView];
    cell.model =  self.dataArray[indexPath.row];
    return cell;
}



@end
