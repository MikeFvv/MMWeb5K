//
//  YHUserInfo.h
//  YouCheLian
//
//  Created by Mike on 15/11/4.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHUserInfo : NSObject
/// 用户ID
@property (nonatomic, assign) NSInteger uId;

@property (nonatomic, copy) NSString *uCarBrand;
/// 昵称
@property (nonatomic, copy) NSString *uNickname;
/// 头像地址
@property (nonatomic, copy) NSString *uHeadUrl;

@property (nonatomic, assign) NSInteger res_code;

@property (nonatomic, copy) NSString *uCarType;
/// 设备默认类型；1=摩托在线，2=后视镜，3=行车记录仪，4=超长待机
@property (nonatomic, assign) NSInteger terminaType;

@property (nonatomic, copy) NSString *uSysNo;
/// 注册时间
@property (nonatomic, copy) NSString *uRegistTime;
/// 对应类型枚举表
@property (nonatomic, copy) NSString *res_desc;
/// 返回编号
@property (nonatomic, assign) NSInteger res_num;
/// 手机号
@property (nonatomic, copy) NSString *uPhone;
/// 1= 男, 2= 女 
@property (nonatomic, assign) NSInteger uSex;

// 是否登录
@property(nonatomic,assign) BOOL isLogin;

// 创建一个单例 在哪都可以拿到
+ (YHUserInfo *)shareInstance;

+ (void)pareseUserInfo:(NSDictionary *)dic;

// 删除内存中的用户数据
+ (void)removeUserInfoModel;


@end




