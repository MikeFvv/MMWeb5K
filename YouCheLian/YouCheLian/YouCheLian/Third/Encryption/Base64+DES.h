//
//  Base64+DES.h
//  usale0001
//
//  Created by YU on 15/12/1.
//  Copyright © 2015年 YU. All rights reserved.
//

#import <Foundation/Foundation.h>
/******字符串转base64（包括DES加密）******/
#define __BASE64( text )        [Base64_DES base64StringFromText:text]

/******base64（通过DES解密）转字符串******/
#define __TEXT( base64 )        [Base64_DES textFromBase64String:base64]

@interface Base64_DES : NSObject

// 加密
+ (NSString *)base64StringFromText:(NSString *)text;

// 解密
+ (NSString *)textFromBase64String:(NSString *)base64;
@end
