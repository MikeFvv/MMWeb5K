//
//  UserDefaultsTools.h
//  YouCheLian
//
//  Created by Mike on 16/5/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsTools : NSObject


// 保存bool值的方法
+ (void)setBool:(bool)value forKey:(NSString *)key;

// 读取bool值的方法
+ (BOOL)boolForKey:(NSString *)key;



+ (void)setObject:(id)object forKey:(NSString *)key;

+ (NSArray *)arrayForKey:(NSString *)key;

+ (NSString *)stringForKey:(NSString *)key;

+ (id)objectForKey:(NSString *)key;



///  清除指定key
+ (void)removeObjectForKey:(NSString *)key;

///  清除偏好设置数据 - 所有的 NSUserDefault 的数据
+ (void)removeDefaults;



+(void)print;

@end
