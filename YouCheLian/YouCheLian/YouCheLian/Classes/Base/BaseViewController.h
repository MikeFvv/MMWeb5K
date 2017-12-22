//
//  BaseViewController.h
//  YouCheLian
//
//  Created by Mike on 15/11/4.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
///**
// *  传递属性
// */
//@property(nonatomic,strong) NSMutableDictionary *para;
///**
// *  数据源数组
// */
//@property(nonatomic,strong) NSMutableArray *array;
//

// 显示隐藏导航栏  YES 隐藏  NO 显示
@property (nonatomic, assign) BOOL isShowNav;  // 默认值 NO


- (void)showLoadingView;

- (void)hidenLoadingView;
- (void)showLoadingViewWithText:(NSString *)str;

- (void)showErrorMessage:(NSString *)message;
- (void)showMessage:(NSString *)message delay:(NSTimeInterval)delay;


@end
