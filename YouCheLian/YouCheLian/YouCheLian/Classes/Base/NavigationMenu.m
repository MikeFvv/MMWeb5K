//
//  NavigationMenu.m
//  YouCheLian
//
//  Created by Mike on 15/11/19.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "NavigationMenu.h"

@implementation MenuButton

- (instancetype)initWithTitle:(NSString *)title buttonIcon:(UIImage *)icon {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _title = title;
    _icon = icon;
    return self;
}

@end



static CGFloat menuWidth = 110; // 菜单宽度
static CGFloat rowHeight = 50;  // 菜单高度
static CGFloat titleFontSize = 17.0;  // 字体大小

@implementation NavigationMenu

- (instancetype)initWithItems:(NSArray *)items {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self = [super initWithFrame:CGRectMake(screenWidth - menuWidth, 0, menuWidth, 0)];
    if (!self) {
        return nil;
    }
    
    _items = items;
    CGFloat menuHeight = rowHeight * items.count;
    self.beforeAnimationFrame = CGRectMake(screenWidth - menuWidth, -menuHeight, menuWidth, menuHeight);
    self.afterAnimationFrame = CGRectMake(screenWidth - menuWidth, 64, menuWidth, menuHeight);
    self.frame = self.beforeAnimationFrame;
    
    _background = [[UIView alloc] initWithFrame:CGRectZero];
    _background.backgroundColor = [UIColor blackColor];
    _background.alpha = 0.05;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_background addGestureRecognizer:gesture];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.items enumerateObjectsUsingBlock:^(MenuButton *obj, NSUInteger idx, BOOL *stop) {
        
        CGFloat buttonY = idx * rowHeight;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, buttonY, menuWidth, rowHeight);
        button.backgroundColor = [UIColor whiteColor];
        button.tag = idx; // set button tag
        [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:obj.icon];
        icon.center = CGPointMake(icon.frame.size.width/2+15, rowHeight/2);
        [button addSubview:icon];
        
        CGFloat labelX = icon.frame.origin.x+icon.frame.size.width+20;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, icon.frame.origin.y-10, menuWidth-labelX, 20)];
        label.text = obj.title;
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = kFontColor;
        label.font = [UIFont systemFontOfSize:titleFontSize];
        [button addSubview:label];
        
        UIView *separatar = [[UIView alloc] initWithFrame:CGRectMake(0, rowHeight-0.5, menuWidth, 1)];
        separatar.backgroundColor = [UIColor blackColor];
        separatar.alpha = 0.1;
        if (idx < self.items.count-1) {
            [button addSubview:separatar];
        }
    }];
}

- (void)showInNavigationController:(UINavigationController *)navigationController didTapBlock:(void(^)(UIButton *button))didTapBlock {
    
    self.didTapBtnBlock = didTapBlock;
    
    [navigationController.view insertSubview:self.background belowSubview:navigationController.navigationBar];
    [navigationController.view insertSubview:self belowSubview:navigationController.navigationBar];
    
    self.background.frame = navigationController.view.frame;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = self.afterAnimationFrame;
    } completion:^(BOOL finished) {
        self.isOpen = YES;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = self.beforeAnimationFrame;
        [self.background removeFromSuperview];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.isOpen = NO;
    }];
}


- (void)didTapButton:(UIButton *)button{
    if (self.didTapBtnBlock) {
        self.didTapBtnBlock(button);
    }
    [self dismiss];
}

@end
