//
//  JoDes.h
//  YouCheLian
//
//  Created by Mike on 15/12/2.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


@interface JoDes : NSObject
// 加密
+ (NSString *) encode:(NSString *)str key:(NSString *)key;
// 解密
+ (NSString *) decode:(NSString *)str key:(NSString *)key;

@end
