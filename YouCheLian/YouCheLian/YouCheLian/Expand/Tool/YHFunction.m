//
//  YHFunction.m
//
//
//  Created by Mike on 15/11/4.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "YHFunction.h"
#import "MD5.h"

@implementation YHFunction



#pragma mark - 保存 用户类 数据
//保存用户类数据
+ (void)saveUserInfoWithDic:(NSDictionary *)info {
    
    // 获取沙盒路径
    // NSString *path = NSHomeDirectory();
    NSString *path =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    //
    NSString *file = [path stringByAppendingPathComponent:@"userInfo.plist"];
//    YHLog(@"路径===%@", file);
//    YHLog(@"打印数据%@", info);
    [info writeToFile:file atomically:YES];
    
}

#pragma mark - 获取 用户类 数据
// 读取用户类数据信息  存放在用户类
+ (void)readUserInfo {
    
    NSString *file = [YHFunction getUserPath];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:file];
    
    // // 存放在用户 模型类
    [YHUserInfo pareseUserInfo:dic];
}

/// 获取沙盒用户信息
///
/// 返回用户字典
+ (NSDictionary *)getUserInfo {
    
    NSString *file = [YHFunction getUserPath];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:file];
    return dict;
}


// 删除用户类信息
+ (void)removeUserInfoPlist {
    
    NSString *file = [YHFunction getUserPath];
    //第一种方式
    NSDictionary *dic = [NSDictionary dictionary];
    [dic writeToFile:file atomically:YES];
    //第二种方式
//    NSFileManager *manager = [NSFileManager defaultManager];
//    [manager removeItemAtPath:file error:nil];
    
}

+ (NSString *)getUserPath {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *file = [path stringByAppendingPathComponent:@"userInfo.plist"];
    YHLog(@"获取路径===%@", file);
    return file;
}



// 时间戳
+ (NSString *)getTimeScamp{
    
    return [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]];
    
}

// MD5
+ (NSString *)md5StringFromArray:(NSArray *)array{
    
    NSMutableString *item = [NSMutableString string];
    
    [array enumerateObjectsUsingBlock:^(NSString *str , NSUInteger idx, BOOL *stop) {
        
        [item appendString:str];
        
    }];
    return  [MD5 MD5Encrypt:item];
}


#pragma mark - 优车联请求数据加密串
/// （优车联加密） 字典key转换小写-排序后 value值拼接后+钥匙 MD5加密
///
/// @param dictParam 要加密的字典参数
///
/// @return 加密字符串
+ (NSString *)md5StringFromDictionary:(NSMutableDictionary *)dictParam {
    
    
    NSMutableArray *lowArray = [NSMutableArray array];
    NSMutableDictionary *newMDict = [NSMutableDictionary dictionary];
    // 转小写
    [dictParam enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *keyStr = [key lowercaseString];  // 转小写
        [lowArray addObject:keyStr];  // 把小写key值用数组保存
        [newMDict setValue:value forKey:keyStr]; // 从新保存字典
    }];
    
    // 数组用系统方法compare做字母排序
    NSArray *newArray = [lowArray sortedArrayUsingSelector:@selector(compare:)];
    
    // 根据排序后的key 把字典的值取出来拼接  拼接后准备加密
    NSMutableString *valueJointMStr = [NSMutableString string];
    
    for(NSString* keyStr in newArray)
    {
        [valueJointMStr appendString:[newMDict objectForKey:keyStr]];
    }
    // 添加  MD5key
    [valueJointMStr appendString:MD5key];
    // 加密返回
    return  [MD5 MD5Encrypt:valueJointMStr];
}


#pragma mark - url  账号 加密
///  url 账号密码 加密传给后台  不需再传另外参数的方法
///
///  @param 需带账号验证的 url
///
///  @return 加密后 url
+ (NSString *)joDesaccountPassWordUrl:(NSString *)url {
    
    NSString *service = [NSBundle mainBundle].bundleIdentifier;  // 获取唯一的字符标识
    
    //登录信息  账号和密码
    NSString *strPass = [NSString stringWithFormat:@"%@%@",[YHUserInfo shareInstance].uPhone,[SSKeychain passwordForService:service account:[YHUserInfo shareInstance].uPhone]];
    NSString *joDesStr = [JoDes encode:strPass key:kWebDESKey];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@&lg=%@",[[GetUrlString sharedManager] urlLoginWeb],url ,joDesStr];
    return urlStr;
}


///  @return 根据是否登录返回不同的URl
+ (NSString *)getWebUrlWithUrl:(NSString *)url {
    
    NSString *urlStr = nil;
    if ([[YHUserInfo shareInstance] isLogin]) {//登录状态时
        NSString *service = [NSBundle mainBundle].bundleIdentifier;  // 获取唯一的字符标识
        //登录信息  账号和密码
        NSString *strPass = [NSString stringWithFormat:@"%@%@",[YHUserInfo shareInstance].uPhone,[SSKeychain passwordForService:service account:[YHUserInfo shareInstance].uPhone]];
        NSString *joDesStr = [JoDes encode:strPass key:kWebDESKey];
        NSString *encodeUrl = (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (CFStringRef)url,
                                                                  NULL,
                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                  kCFStringEncodingUTF8));
        
        urlStr = [NSString stringWithFormat:@"%@%@&lg=%@",[[GetUrlString sharedManager] urlLoginWeb],encodeUrl,joDesStr];
        
    }else{//未登录时
        
        urlStr = url;
        
    }
    
    
    return urlStr;
    
}


///  @return 加密后的登录信息
+ (NSString *)joDesReturnJoDes {
    
    NSString *service = [NSBundle mainBundle].bundleIdentifier;  // 获取唯一的字符标识
    
    //登录信息  账号和密码
    NSString *strPass = [NSString stringWithFormat:@"%@%@",[YHUserInfo shareInstance].uPhone,[SSKeychain passwordForService:service account:[YHUserInfo shareInstance].uPhone]];
    NSString *joDesStr = [JoDes encode:strPass key:kWebDESKey];
    
    return joDesStr;
}


#pragma mark - 获取Plist 文件数据
///  获取Plist 文件数据
///
///  @param string plist 文件名
///
///  @return 数组
+(NSArray *)arrayWithString:(NSString *)string{
    // 获得资源包对象 获得Plist文件的全路径 从文件中加载数组
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:string ofType:nil];
    // 无缓存（图片所占用的内存会在一些特定操作后被清除） 从文件中加载数组
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:plistPath];
    return array;
}


+ (id)UIStoryboardPush:(NSString *)ClassName  {
    
    UIStoryboard *strory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id sweVC = [strory instantiateViewControllerWithIdentifier:ClassName];
    return sweVC;
}


///  字典转json格式字符串
///
///  @param dic 需转换的字典
///
///  @return json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    if (dic == nil) {
        return @"字典是空值!";
    }
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

///  MB HUD 弹框提示信息
///
///  @param message 提示 内容
///  @param delay   延时多少秒 消失
+ (void)showMessage:(NSString *)message delay:(NSTimeInterval)delay {
    MBProgressHUD *hub = [[MBProgressHUD alloc] init];
    hub.labelText = message;
    [hub show:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:hub];
    [hub hide:YES afterDelay:delay];
}



@end











