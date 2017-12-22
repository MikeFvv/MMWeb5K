//
//  NSString+HTML.m
//  TXZS
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSString+HTML.h"

@implementation NSString (HTML)
//全局变量
static NSDictionary *htmlEscapes = nil;
static NSDictionary *htmlUnescapes = nil;

+ (NSDictionary *)htmlEscapes
{
    if (!htmlEscapes) {
        htmlEscapes = [[NSDictionary alloc] initWithObjectsAndKeys:
                       @"&amp;", @"&",
                       @"&lt;", @"<",
                       @"&gt;", @">",
                       nil
                       ];
    }
    return htmlEscapes;
}

+ (NSDictionary *)htmlUnescapes
{
    if (!htmlUnescapes) {
        htmlUnescapes = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"&", @"&amp;",
                         @"<", @"&lt;",
                         @">", @"&gt;",
                         nil
                         ];
    }
    return htmlEscapes;
}

static NSString *replaceAll(NSString *s, NSDictionary *replacements)
{
    for (NSString *key in replacements) {
        NSString *replacement = [replacements objectForKey:key];
        s = [s stringByReplacingOccurrencesOfString:key withString:replacement];
    }
    return s;
}

- (NSString *)htmlEscapedString
{
    return replaceAll(self, [[self class] htmlEscapes]);
}

- (NSString *)htmlUnescapedString
{
    return replaceAll(self, [[self class] htmlUnescapes]);
}



+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim
{
//    NSLog(@"html is %@",html);
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    NSString*str = @" ";
    while ([theScanner isAtEnd] == NO)
    {
        //find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        //find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:str];
    }
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

@end
