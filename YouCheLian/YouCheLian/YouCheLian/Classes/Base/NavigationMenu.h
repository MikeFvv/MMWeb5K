//
//  NavigationMenu.h
//  YouCheLian
//
//  Created by Mike on 15/11/19.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuButton : NSObject

/*!
   Button 标题
 */
@property (copy, nonatomic, readonly) NSString *title;

/*!
   Button 图片
 */
@property (strong, nonatomic, readonly) UIImage *icon;

/*!
   Button 初始化
 @param title title
 @param icon icon
 */
- (instancetype)initWithTitle:(NSString *)title buttonIcon:(UIImage *)icon;

@end



@interface NavigationMenu : UIView

@property (copy, nonatomic, readonly) NSArray *items;
@property (strong, nonatomic) UIView *background;
@property (copy, nonatomic) void (^didTapBtnBlock)(UIButton *button);

@property BOOL isOpen;
@property CGRect beforeAnimationFrame;
@property CGRect afterAnimationFrame;

/*!
   菜单初始化
 @param items Items of MenuButton
 */
- (instancetype)initWithItems:(NSArray *)items;

/*!
   显示菜单
 @param navigationController Menu's NavigationController
 @param didTapBlock block of tap button done
 */
- (void)showInNavigationController:(UINavigationController *)navigationController didTapBlock:(void(^)(UIButton *button))didTapBlock;

/*!
   关闭 菜单
 */
- (void)dismiss;

@end
