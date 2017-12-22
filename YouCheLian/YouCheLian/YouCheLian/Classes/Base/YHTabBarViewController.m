//
//  YHTabBarViewController.m
//  YouCheLian
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "YHTabBarViewController.h"
#import "YHNavigationController.h"
#import "YHTabBar.h"
#import "MeViewController.h"
#import "HomeViewController.h"
#import "FoundViewController.h"
#import "DeviceWebViewController.h"
#import "LoginViewController.h"

@interface YHTabBarViewController ()<tabbarDelegate>

@property(nonatomic ,strong)YHTabBar *costomTabBar;
//优宝
@property (nonatomic, strong) DeviceWebViewController *deviceVC;

@end

@implementation YHTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化tabbar
    [self setUpTabBar];

    //添加子控制器
    [self setUpAllChildViewController];
}

//取出系统自带的tabbar并把里面的按钮删除掉
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    for ( UIView * child in  self.tabBar.subviews) {
        
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

-(void)setUpTabBar{
    YHTabBar *customTabBar = [[YHTabBar alloc]init];
    customTabBar.delegate = self;
//    customTabBar.backgroundColor = [UIColor redColor];
    customTabBar.frame = self.tabBar.bounds;
    self.costomTabBar = customTabBar;
    [self.tabBar addSubview:customTabBar];
    
}

-(void)tabBar:(YHTabBar *)tabBar didselectedButtonFrom:(int)from to:(int)to{
    NSLog(@"%d, %d", from, to);
    self.selectedIndex = to;
    NSLog(@"%lu", (unsigned long)self.selectedIndex);
    
    if(self.selectedIndex == 1) {
        //清除uiwebview缓存
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        //重新加载页面
        [self.deviceVC.webView stopLoading];
        NSString *prame = [YHUserInfo shareInstance].uPhone ? [YHUserInfo shareInstance].uPhone : @"0";
        NSString *str = [NSString stringWithFormat:@"%@?phone=%@",[[GetUrlString sharedManager] urlYouBao],prame];
        self.deviceVC.urlStr = str;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        [self.deviceVC.webView loadRequest:request];
    }
    
}

-(void)setUpAllChildViewController {

    // 首页
    HomeViewController *home = [[HomeViewController alloc] init];
    [self setupChildViewController:home title:@"首页" imageName:@"tabbar_home" seleceImageName:@"tabbar_home_selected"];
    
    // 优宝  点击时才给URL
    DeviceWebViewController *menuWebVC = [[DeviceWebViewController alloc]init];
    menuWebVC.leftBarbuttonHidden = YES;
    
    self.deviceVC = menuWebVC;
    [self setupChildViewController:menuWebVC title:@"优宝" imageName:@"tabbar_device" seleceImageName:@"tabbar_device_selected"];
    
    // 发现
    // 代码创建
    FoundViewController *found = [[FoundViewController alloc] init];
    [self setupChildViewController:found title:@"发现" imageName:@"tabbar_found" seleceImageName:@"tabbar_found_selected"];
    
    // 我的
    MeViewController *me = [[MeViewController alloc] init];
    [self setupChildViewController:me title:@"我的" imageName:@"tabbar_me" seleceImageName:@"tabbar_me_selected"];
}


-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName{
//    controller.title = title;
    controller.tabBarItem.title = title; // 设置跟Nav title一样文字
    controller.tabBarItem.image = [UIImage imageNamed:imageName];
    controller.tabBarItem.selectedImage = [UIImage imageNamed:selectImageName];
    
    //包装导航控制器
    YHNavigationController *nav = [[YHNavigationController alloc]initWithRootViewController:controller];
    [self addChildViewController:nav];
    [self.costomTabBar addTabBarButtonWithItem:controller.tabBarItem];
    
}




@end






