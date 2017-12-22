//
//  YHNavigationController.m
//  YouCheLian
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "YHNavigationController.h"

@interface YHNavigationController ()

@end

@implementation YHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.translucent = NO;
    
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.192  green:0.200  blue:0.200 alpha:1], NSForegroundColorAttributeName, YHFont(16, NO), NSFontAttributeName, nil]];
    
    // 设置导航栏 Nav 头部颜色
    self.navigationBar.barTintColor = kNavColor;
//    [self.navigationController.navigationBar setBarTintColor:kNavColor];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;//视图控制器，四条边不指定
        self.extendedLayoutIncludesOpaqueBars = NO;//不透明的操作栏
        self.modalPresentationCapturesStatusBarAppearance = NO;
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@""]
                                          forBarPosition:UIBarPositionTop
                                              barMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@""]
                                 forBarMetrics:UIBarMetricsDefault];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
