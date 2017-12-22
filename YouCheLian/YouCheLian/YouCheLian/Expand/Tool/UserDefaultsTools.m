//
//  UserDefaultsTools.m
//  YouCheLian
//
//  Created by Mike on 16/5/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UserDefaultsTools.h"

@implementation UserDefaultsTools


// 保存bool值的方法
+ (void)setBool:(bool)value forKey:(NSString *)key {
    if (key == nil || [key isEqualToString:@""]) {
        return;
    }
    
    // 获得NSUserDefaults对象
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 保存数据
    [defaults setBool:value forKey:key];
    // 立即同步
    [defaults synchronize];
}

// 读取bool值的方法
+ (bool)boolForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}




+ (void)setObject:(id)object forKey:(NSString *)key {
    
    if (key == nil || [key isEqualToString:@""]) {
        return;
    }
    // 获得NSUserDefaults对象
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 保存数据
    [defaults setObject:object forKey:key];
    // 立即同步  强制让数据立刻保存
    [defaults synchronize];
}



+ (NSArray *)arrayForKey:(NSString *)key {
    
    return [[NSUserDefaults standardUserDefaults] arrayForKey:key];
}

+ (NSString *)stringForKey:(NSString *)key {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

+ (id)objectForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}




///  移除指定key
+ (void)removeObjectForKey:(NSString *)key {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

///  清除偏好设置数据 - 所有的 NSUserDefault 的数据
+ (void)removeDefaults {
    //方法一
    //    NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
    //    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
    
    //方法二
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defs dictionaryRepresentation];
    
    for(id key in dict) {
        
        if ([key isEqualToString:@"launched"]) {
            break;
        }
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

+(void)print {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    YHLog(@"%@",dic);
}


@end






