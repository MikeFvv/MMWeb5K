//
//  UIBarButtonItem+Extension.h
//  
//
//  Created by Mike on 15/6/12.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (instancetype)BarButtonItemWithTitle:(NSString *) title style:(UIBarButtonItemStyle) style target:(id)target action:(SEL) action;

+ (instancetype)BarButtonItemWithBackgroudImageName:(NSString *)backgroudImage highBackgroudImageName:(NSString *)highBackgroudImageName target:(id)target action:(SEL)action;
+ (instancetype)BarButtonItemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName title:(NSString *)title target:(id)target action:(SEL)action;
@end
