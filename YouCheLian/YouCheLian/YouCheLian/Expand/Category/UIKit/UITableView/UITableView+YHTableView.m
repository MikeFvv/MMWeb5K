//
//  UITableView+YHTableView.m
//  YouCheLian
//
//  Created by Mike on 15/11/10.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "UITableView+YHTableView.h"

@implementation UITableView (YHTableView)

+ (UITableView *)initWithTableView:(CGRect)frame withDelegate:(id)delegate
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    //将系统的Separator左边不留间隙
    tableView.separatorInset = UIEdgeInsetsZero;
    return tableView;
}

@end
