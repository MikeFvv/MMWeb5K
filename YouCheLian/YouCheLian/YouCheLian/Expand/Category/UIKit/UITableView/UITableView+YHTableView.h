//
//  UITableView+YHTableView.h
//  YouCheLian
//
//  Created by Mike on 15/11/10.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (YHTableView)
/**
 *  快速创建tableView
 *
 *  @param frame    tableView的frame
 *  @param delegate 代理
 *
 *  @return 返回一个自定义的tableView
 */
+ (UITableView *)initWithTableView:(CGRect)frame withDelegate:(id)delegate;
@end
