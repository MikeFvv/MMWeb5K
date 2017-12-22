//
//  NSString+Size.h
//  TXZS
//
//  Created by apple on 15/11/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//  动态计算尺寸

#import <Foundation/Foundation.h>

@interface NSString (Size)
/**
 *  动态计算文字的宽高（多行）
 *
 *  @param font 文字的字体
 *  @param size 限制的范围
 *
 *  @return 计算的宽高
 */
- (CGSize) sizeWithContentFont:(UIFont *)font limitSize:(CGSize)limitSize;
/**
 *  动态计算文字的宽高
 *
 *  @param font 文字的字体
 *  @param width 限制宽度 ，高度不限制
 *
 *  @return 计算的宽高
 */
- (CGSize) sizeWithContentFont:(UIFont *)font limitWidth:(CGFloat)width;
/**
 *  动态计算文字的宽高（单行）
 *
 *  @param font 文字的字体
 *
 *  @return 计算的宽高
 */
- (CGSize) sizeWithContentFont:(UIFont *)font ;


@end
