//
//  NetworkTools.h
//
//  Created by Mike on 15/3/22.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

/// 网络请求枚举
typedef enum : NSUInteger {
    GET,
    POST,
} RequestMethod;

@interface NetworkTools : AFHTTPSessionManager

+ (instancetype)sharedTools;

- (void)request:(RequestMethod)method urlString:(NSString *)urlString parameters:(id)parameters finished:(BOOL (^)(id result, NSError * error))finished;

- (void)request:(RequestMethod)method urlString:(NSString *)urlString parameters:(id)parameters uploadProgress:(void (^)(NSProgress *))uploadProgress downloadProgress:(void (^)(NSProgress *))downloadProgress finished:(BOOL (^)(id, NSError *))finished;


+ (void)showMessage:(NSString *)message delay:(NSTimeInterval)delay;





///**
// *  get请求
// *
// *  @param url        请求路径
// *  @param parameters 请求普通参数
// *  @param success    成功返回所需要执行的block
// *  @param error      失败返回所需要执行block
// */
//+ (void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id reponseObject)) success failure:(void (^)(NSError *)) error;
///**
// *  post请求（不带文件流传输）
// *
// *  @param url        请求路径
// *  @param parameters 请求普通参数
// *  @param success    成功返回所需要执行的block
// *  @param error      失败返回所需要执行block
// */
//+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id reponseObject)) success failure:(void (^)(NSError *)) failure;
///**
// *  post请求（带文件上传）
// *
// *  @param url        请求路径
// *  @param parameters 请求普通参数
// *  @param fileData   传输的文件流
// *  @param success    成功返回所需要执行的block
// *  @param failure    失败返回所需要执行block
// */
//+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters fileData:(void (^)(id<AFMultipartFormData> formData)) fileData success:(void (^)(id reponseObject)) success failure:(void (^)(NSError *)) failure;




/**
 *  监控网络状态
 *
 *  @param status 网络状态类型
 */
+ (void)monitoringReachabilityStatus:(void (^)(AFNetworkReachabilityStatus)) statusBlock;
/**
 *  是否展示网络激活指示器
 */
+ (void)showNetworkActivityIndicator;

@end





