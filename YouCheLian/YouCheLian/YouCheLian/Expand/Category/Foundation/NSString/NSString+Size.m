//
//  NSString+Size.m
//  TXZS
//
//  Created by apple on 15/11/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSString+Size.h"
#define kIOS7LATER      ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
@implementation NSString (Size)
/**
 *  动态计算文字的宽高（多行）
 *
 *  @param font 文字的字体
 *  @param size 限制的范围
 *
 *  @return 计算的宽高
 */
- (CGSize) sizeWithContentFont:(UIFont *)font limitSize:(CGSize)limitSize
{
    return [self boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;

}
/**
 *  动态计算文字的宽高
 *
 *  @param font 文字的字体
 *  @param width 限制宽度 ，高度不限制
 *
 *  @return 计算的宽高
 */
- (CGSize) sizeWithContentFont:(UIFont *)font limitWidth:(CGFloat)width
{
    CGSize limitSize = CGSizeMake(width, MAXFLOAT);
    return [self sizeWithContentFont:font limitSize:limitSize];
}
/**
 *  动态计算文字的宽高（单行）
 *
 *  @param font 文字的字体
 *
 *  @return 计算的宽高
 */
- (CGSize) sizeWithContentFont:(UIFont *)font
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    return [self sizeWithAttributes:attributes];
}
@end
