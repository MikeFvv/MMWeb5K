//
//  YHFunction.h
//
//
//  Created by Mike on 15/11/4.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHFunction : NSObject


#pragma mark - 保存 用户类 数据
//保存用户数据
+ (void)saveUserInfoWithDic:(NSDictionary *)info;

#pragma mark - 获取 用户类 数据
//读取用户类数据信息
+ (void)readUserInfo;

/// 获取沙盒用户信息
///
/// 返回用户字典
+ (NSDictionary *)getUserInfo;

//删除用户类信息
+ (void)removeUserInfoPlist;

// 删除内存中的用户类数据
//+ (void)removeUserInfoModel;



//时间戳
+ (NSString *)getTimeScamp;

//MD5
+ (NSString *)md5StringFromArray:(NSArray *)array;


//+ (BOOL)getBooleanWithKey:(NSString *)key;


/// （优车联加密） 排序后 MD5加密
///
/// @param array 要加密的字典的key值数组
///
/// @return 加密字符串
+ (NSString *)md5StringFromDictionary:(NSMutableDictionary *)dictParam;


///  url 账号密码 加密传给后台  不需再传另外参数的方法
///
///  @param 需带账号验证的 url
///
///  @return 加密后 url
+ (NSString *)joDesaccountPassWordUrl:(NSString *)url;

///  @return 加密后的登录信息
+ (NSString *)joDesReturnJoDes;



///  @return 根据是否登录返回不同的URl
+ (NSString *)getWebUrlWithUrl:(NSString *)url;



///  获取Plist 文件数据
///
///  @param string plist 文件名
///
///  @return 数组
+(NSArray *)arrayWithString:(NSString *)string;



+ (id)UIStoryboardPush:(NSString *)ClassName;


///  字典转json格式字符串
///
///  @param dic 需转换的字典
///
///  @return json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

+ (void)showMessage:(NSString *)message delay:(NSTimeInterval)delay;




@end
