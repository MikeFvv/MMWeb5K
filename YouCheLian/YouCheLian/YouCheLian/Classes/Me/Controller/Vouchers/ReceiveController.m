//
//  ShopViewController.m
//  YouCheLian
//
//  Created by Mike on 15/11/26.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "ReceiveController.h"
#import <MJExtension.h>
#import "VouchersModel.h"
#import "ReceiveCell.h"
#import "VoucherNoCell.h"


@interface ReceiveController ()

@property (nonatomic, strong) VouchersModel *collectionModel;

@end

@implementation ReceiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 清除tableView 后面多于的分割线
    //    self.tableView.tableFooterView = [[UIView alloc]init];
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
    
    ReceiveCell *cell = [ReceiveCell cellWithTableView:tableView];
    cell.model =  self.dataArray[indexPath.row];
    return cell;
}



@end
