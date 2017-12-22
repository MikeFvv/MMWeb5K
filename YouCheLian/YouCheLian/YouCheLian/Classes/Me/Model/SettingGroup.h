//
//  HMSettingGroup.h
//  网易彩票
//
//  Created by Apple on 15/7/12.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingGroup : NSObject
/**
 *  装载这一组对应的所有行模型(元素类型:HMSettingItem)
 */
@property(nonatomic,strong) NSArray *items;
/**
 *  该组对应的头部描述
 */
@property(nonatomic,copy)NSString *headerTitle;
/**
 *  该组对应尾部描述
 */
@property(nonatomic,copy)NSString *footerTitle;

+(instancetype)groupWithItems:(NSArray *)items;
@end
