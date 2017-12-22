//
//  NSString+DM.m
//  DongMenBao
//
//  Created by Leaf on 14/10/31.
//  Copyright (c) 2014年 zeasy. All rights reserved.
//

#import "NSString+Valid.h"
#define IOS7_OR_LATER      ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)


@implementation NSString (Valid)

- (BOOL) isChinese
{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}


+( BOOL)IsIncludeChinese:(NSString *)str
{
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}
    

+ (BOOL)isEmpty:(NSString *)str
{
    if (!str)
    {
        return YES;
    }
    
    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if ([str isEqualToString:@""]) {
        return YES;
    }
    return NO;
}



+ (BOOL)isNotEmpty:(NSString *)str
{
    return ![NSString isEmpty:str];
}


+ (BOOL)validMobile:(NSString *)str
{
    NSString *phoneRegex = @"^1[34578]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:str];
}

#pragma mark - 判断字符串为字母或者数字
+ (BOOL)validCharacterOrNumber:(NSString *)str
{
    // 编写正则表达式：只能是数字或英文，或两者都存在
    NSString *regex = @"^[a-z0－9A-Z]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:str];
}


+ (BOOL)isNumText:(NSString *)str
{
    NSString * regex  = @"(^[0-9]*$)";
    NSPredicate * pred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}

#pragma mark - 根据字体来确定宽高 ---宽高不限制
- (CGSize) sizeWithFont:(UIFont *)font
{
    CGSize theSize;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    theSize = [self sizeWithAttributes:attributes];
    theSize.width = ceil(theSize.width);
    theSize.height = ceil(theSize.height);
    return theSize;
}
#pragma mark - 根据
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize theSize;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    theSize.width = ceil(rect.size.width);
    theSize.height = ceil(rect.size.height);
    return theSize;
}

#pragma mark - NSNumber ---NSString
+ (NSString *)stringValue:(NSString *)str
{
    if (!str)
    {
        return @"";
    }
    if ([str isKindOfClass:[NSNumber class]])
    {
        NSNumber *number = (NSNumber *)str;
        return [number stringValue];
    }
    
    if (![str isKindOfClass:[NSString class]])
    {
        return @"";
    }
    return str;
}
@end
