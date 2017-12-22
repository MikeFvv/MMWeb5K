//
//  WWPinyinGroup.h
//  TableViewIndex
//
//  Created by Mike on 15/12/8.
//  Copyright © 2015年 微微. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  获取model数组
 */
UIKIT_EXTERN NSString *const LEOPinyinGroupResultKey;

/**
 *  获取所包函字母的数组
 */
UIKIT_EXTERN NSString *const LEOPinyinGroupCharKey;

@interface WWPinyinGroup : NSObject

/*
 参数group:未排训分组的model数组
 参数key:根据model中的那个属性排训
 */
+(NSDictionary *)group:(NSArray *)datas key:(NSString *)key;

@end
