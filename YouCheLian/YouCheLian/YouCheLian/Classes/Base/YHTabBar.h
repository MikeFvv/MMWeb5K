//
//  YHTabBar.h
//  YouCheLian
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHTabBarButton.h"

@class YHTabBar;

//给每个按钮定义协议 与 方法
@protocol tabbarDelegate <NSObject>
@optional
-(void)tabBar:(YHTabBar * )tabBar didselectedButtonFrom:(int)from to:(int)to;
@end

@interface YHTabBar : UIView
@property (weak ,nonatomic)YHTabBarButton *selectedButton;
/**
 *  给自定义的tabbar添加按钮
 */
-(void)addTabBarButtonWithItem:(UITabBarItem *)itme;
@property(nonatomic , weak) id <tabbarDelegate> delegate;



@end
