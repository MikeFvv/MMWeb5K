//
//  UIBarButtonItem+YHBarButtonItem.m
//  YouCheLian
//
//  Created by Mike on 15/11/10.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "UIBarButtonItem+YHBarButtonItem.h"

@implementation UIBarButtonItem (YHBarButtonItem)

+ (UIBarButtonItem *)initWithNormalImage:(NSString *)image target:(id)target action:(SEL)action width:(CGFloat)width height:(CGFloat)height
{
    UIImage *normalImage = [UIImage imageNamed:image];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, width, height);
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
+ (UIBarButtonItem *)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}
@end
