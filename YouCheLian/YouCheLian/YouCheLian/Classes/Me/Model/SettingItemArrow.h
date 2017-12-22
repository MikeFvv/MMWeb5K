//
//  SettingItemArrow.h
//  YouCheLian
//
//  Created by Mike on 15/11/23.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "SettingItem.h"

@interface SettingItemArrow : SettingItem
/**
 *  要跳转的控制器
 */
@property(nonatomic,assign) Class destVc;

//@property(nonatomic,assign) BOOL jumpType; // 0 push 1 modal

+(instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon destVc:(Class)destVC;

+(instancetype)itemWithTitle:(NSString *)title destVc:(Class)destVC;
@end
