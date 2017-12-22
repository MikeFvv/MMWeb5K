//
//  NetworkTools.m
//
//  Created by Mike on 15/11/4.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "NetworkTools.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <MBProgressHUD.h>
#import "Reachability.h"

/// 网络工具协议
@protocol NetworkToolsProxy <NSObject>

// 声明 AFN `内置`的一个方法，已经内置实现好了！
@optional
//- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
//                                       URLString:(NSString *)URLString
//                                      parameters:(id)parameters
//                                         success:(void (^)(NSURLSessionDataTask *, id))success
//                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;


- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end

// 遵守协议，不实现方法，再调用的时候，会调用父类的方法
@interface NetworkTools() <NetworkToolsProxy>

@end

@implementation NetworkTools

+ (instancetype)sharedTools {
    static NetworkTools *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetworkTools alloc] initWithBaseURL:nil];
        
        // 申明请求的数据是json类型
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置延时最长时间请求
        instance.requestSerializer.timeoutInterval = 60;
        // 设置反序列化支持的数据格式
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    });
    
    return instance;
}

// 包装 AFN 内置的网络方法
// request方法，既能够做 GET 又能够做 POST
- (void)request:(RequestMethod)method urlString:(NSString *)urlString parameters:(id)parameters finished:(BOOL (^)(id, NSError *))finished {
    
    NSString *methodString = (method == GET) ? @"GET" : @"POST";
    
    [[self dataTaskWithHTTPMethod:methodString URLString:urlString parameters:parameters uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        finished(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finished(nil, error);
        BOOL errorBool = finished(nil, error);
        if (errorBool) {
            [NetworkTools dealWithError:error];
        }
    } ] resume];
}


// 包装 AFN 内置的网络方法
// request方法，既能够做 GET 又能够做 POST
- (void)request:(RequestMethod)method urlString:(NSString *)urlString parameters:(id)parameters uploadProgress:(void (^)(NSProgress *))uploadProgress downloadProgress:(void (^)(NSProgress *))downloadProgress finished:(BOOL (^)(id, NSError *))finished {
    
    NSString *methodString = (method == GET) ? @"GET" : @"POST";
    
    [[self dataTaskWithHTTPMethod:methodString URLString:urlString parameters:parameters uploadProgress:^(NSProgress *afnUploadProgress) {
        uploadProgress(afnUploadProgress);
    } downloadProgress:^(NSProgress *afnDownloadProgress) {
        downloadProgress(afnDownloadProgress);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        finished(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finished(nil, error);
        BOOL errorBool = finished(nil, error);
        if (errorBool) {
            [NetworkTools dealWithError:error];
        }
    }]resume];
}


+ (void)dealWithError:(NSError *)error
{
    if ([NetworkTools haveInternet]) {
        // 有网络
        YHLog(@"服务器请求出错");
//        [NetworkTools showMessage:NetDidUnConnectWebService delay:1.0f];
    }else {
        // 没网络
        YHLog(@"无网络链接");
        [NetworkTools showMessage:NetDidLostConnectAlertMessage delay:1.0f];
    }
}

+ (BOOL)haveInternet
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    if ([r currentReachabilityStatus] == NotReachable) {
        return NO;
    }else{
        return YES;
    }
    //        NotReachable: 没有网络连接
    //        ReachableViaWWAN:使用3G网络
    //        ReachableViaWiFi: 使用WiFi网络
}


+ (void)showMessage:(NSString *)message delay:(NSTimeInterval)delay {
    
    MBProgressHUD *hub = [[MBProgressHUD alloc] init];
    hub.mode = MBProgressHUDModeText;
    hub.labelText = message;
    [hub show:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:hub];
    [hub hide:YES afterDelay:delay];
}









/******************************** 下面备用 ********************************/

//+ (void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
//{
//    // 1.获得请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    
//    // 2.发送GET请求
//    [mgr GET:url parameters:parameters
//     success:^(AFHTTPRequestOperation *operation, id responseObj) {
//         if (success) {
//             success(responseObj);
//         }
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         if (failure) {
//             failure(error);
//         }
//     }];
//}

//+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
//{
//    // 1.获得请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    
//    // 2.发送POST请求
//    [mgr POST:url parameters:parameters
//      success:^(AFHTTPRequestOperation *operation, id responseObj) {
//          if (success) {
//              success(responseObj);
//          }
//      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//          if (failure) {
//              failure(error);
//          }
//      }];
//}

//+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters fileData:(void (^)(id<AFMultipartFormData>))fileData success:(void (^)(id))success failure:(void (^)(NSError *))failure
//{
//    // 1.获得请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    
//    // 2.发送POST请求
//    [mgr POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        fileData(formData);
//    }success:^(AFHTTPRequestOperation *operation, id responseObj) {
//        if (success) {
//            success(responseObj);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//}

+ (void)monitoringReachabilityStatus:(void (^)(AFNetworkReachabilityStatus))statusBlock
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 当网络状态改变了，就会调用
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status) {
            statusBlock(status);
            
        }
    }];
    // 开始监控
    [mgr startMonitoring];
    
}

+ (void)showNetworkActivityIndicator
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}



@end












