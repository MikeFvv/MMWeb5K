//
//  Constant.h
//  YouCheLian
//
//  Created by Mike on 16/03/1.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>


// ************** 用户提示信息 **************/
/**
 *  用于功能未做的消息提醒
 */
UIKIT_EXTERN NSString * const FunctionDoNotCompleteAlertMessage;

/**
 * 网络提示 --失去连接  发请求那里
 */
UIKIT_EXTERN NSString * const NetDidLostConnectAlertMessage ;

/**
 * 网络提示 --当网络突然失去连接
 */
UIKIT_EXTERN NSString * const NetDidUnConnectAlertMessage ;

/**
 *  连接服务器失败
 */
UIKIT_EXTERN NSString * const NetDidUnConnectWebService ;
/**
 *  登录提示
 */
UIKIT_EXTERN NSString * const LoginTipMessage;

/**
 *  手机格式验证提示
 */
UIKIT_EXTERN NSString * const CheckMobileMessage;
/**
 *  密码不一致
 */
UIKIT_EXTERN NSString * const PasswordNotConsistent;
/**
 *  密码格式验证提示
 */
UIKIT_EXTERN NSString * const PasswordCheckMessage;

///  账号
UIKIT_EXTERN NSString * const AccountNumber;


// 通知
/*** 登录 ***/
UIKIT_EXTERN NSString * const DidLoginNotification;

// 通知
/*** 登录 ***/
UIKIT_EXTERN NSString * const OpeningPositioning;

// 通知
/**用户重新登录*/
UIKIT_EXTERN NSString * const ReLoginNotification;













