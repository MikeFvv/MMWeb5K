//
//  NSString+HTML.h
//  TXZS
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTML)
/**
 *  IOS中过滤HTML标签
 *
 *  @param html 包含HTML的字符串
 *
 *  @param trim 截取
 */
+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;


/**
 *
 */
- (NSString *)htmlEscapedString;

/**
 *
 */
- (NSString *)htmlUnescapedString;
@end
