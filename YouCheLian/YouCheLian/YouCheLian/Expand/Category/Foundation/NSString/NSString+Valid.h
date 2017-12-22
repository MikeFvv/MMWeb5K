//
//  NSString+DM.h
//  DongMenBao
//
//  Created by Leaf on 14/10/31.
//  Copyright (c) 2014年 zeasy. All rights reserved.
//  正则表达式

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Valid)
/**是否是纯中文*/
- (BOOL) isChinese;
/**是否含有中文*/
+( BOOL)IsIncludeChinese:(NSString *)str;

/**是否为空字符串*/
+ (BOOL)isEmpty:(NSString *)str;

/**是否不为空字符串*/
+ (BOOL)isNotEmpty:(NSString *)str;

/**是否为有效的手机号码*/
+ (BOOL)validMobile:(NSString *)str;

/***判断字符串为字母或者数字*/
+ (BOOL)validCharacterOrNumber:(NSString *)str;

/**判断字符串为纯数字*/
+ (BOOL)isNumText:(NSString *)str;





/***/
- (CGSize)sizeWithFont:(UIFont *)font;
/***/
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
/**字符串的值*/
+ (NSString *)stringValue:(NSString *)str;

@end
