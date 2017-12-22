//
//  UIBarButtonItem+YHBarButtonItem.h
//  YouCheLian
//
//  Created by Mike on 15/11/10.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (YHBarButtonItem)

/**
 *根据图片快速创建一个UIBarButtonItem，自定义大小
 */
+ (UIBarButtonItem *)initWithNormalImage:(NSString *)image target:(id)target action:(SEL)action width:(CGFloat)width height:(CGFloat)height;

+ (UIBarButtonItem *)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

@end
