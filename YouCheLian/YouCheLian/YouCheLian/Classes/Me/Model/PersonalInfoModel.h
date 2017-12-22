//
//  PersonalInfoModel.h
//  YouCheLian
//
//  Created by Mike on 16/3/10.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalInfoModel : NSObject

// 对应类型枚举表
@property (nonatomic, copy) NSString *res_desc;
// 9022
@property (nonatomic, copy) NSString *res_code;
// 返回编号
@property (nonatomic, strong) NSNumber *res_num;
// 男女1=男，2=女 
@property (nonatomic, strong) NSNumber *uSex;
// 昵称
@property (nonatomic, copy) NSString *uNickname;
// 头像url
@property (nonatomic, copy) NSString *uHeadUrl;

@property (nonatomic, strong) NSNumber *uBean;
// 个性签名
@property (nonatomic, copy) NSString *uSignature;
// 0=无,1=摩托在线,2=后视镜用户3=行车记录仪,4=超长待机用户
@property (nonatomic, copy) NSString *myDefaultSys;
// 已经购买的设备，多个用“,”隔开“1，2,3,4
@property (nonatomic, copy) NSString *mySyss;

@end


