//
//  SettingItem.h
//  YouCheLian
//
//  Created by Mike on 15/11/23.
//  Copyright (c) 2015年 Mike. All rights reserved.
// 一个item模型就对应一行cell

#import <Foundation/Foundation.h>

//typedef enum {
//    HMSettingItemNone, // 无
//    HMSettingItemArrow, // 箭头
//    HMSettingItemSwitch, // 开关
//} HMSettingItemType;

typedef void (^OperationBlock)();

@interface SettingItem : NSObject
/**
 *  标题
 */
@property(nonatomic,copy)NSString *title;

/**
 *  图标
 */
@property(nonatomic,copy)NSString *icon;
/**
 *  子标题
 */
@property(nonatomic,copy)NSString *subTitle;

/** 子标题 */
@property (nonatomic, copy) NSString *subtitle;
/** 右边显示的数字标记 */
@property (nonatomic, copy) NSString *badgeValue;

/** 点击这行cell，需要调转到哪个控制器 */
@property (nonatomic, assign) Class destVcClass;
/**
 *  用保存代码块(点击cell不需要跳转，需要执行的代码块)
 */
@property(nonatomic,copy)OperationBlock operationBlock;

/** cell的高度*/
@property (nonatomic , assign) CGFloat cellHeight;

//@property(nonatomic,assign) HMSettingItemType itemType;
+(instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle;
+(instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;
+(instancetype)itemWithTitle:(NSString *)title;
@end



