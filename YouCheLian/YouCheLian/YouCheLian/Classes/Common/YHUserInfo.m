//
//  YHUserInfo.m
//  YouCheLian
//
//  Created by Mike on 15/11/4.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "YHUserInfo.h"

@implementation YHUserInfo

// 用户类单例 只能创建一个用户, 防止多次创建
// 单例内存不销毁  所有的地方都可以用
+ (YHUserInfo *)shareInstance{
    static YHUserInfo *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[YHUserInfo alloc]init];
    });
    return user;
}

+ (void)pareseUserInfo:(NSDictionary *)dic{
    
    if (dic == nil) {
        return;
    }
    [self shareInstance].uId = ((NSNumber *)dic[@"uId"]).intValue;  // !!!
    [self shareInstance].uCarBrand = dic[@"uCarBrand"] ;
    [self shareInstance].uNickname = dic[@"uNickname"];
    [self shareInstance].uHeadUrl = dic[@"uHeadUrl"];
    [self shareInstance].res_code = (NSInteger)dic[@"res_code"];
    [self shareInstance].uCarType = dic[@"uCarType"];
    [self shareInstance].terminaType = (NSInteger)dic[@"terminaType"];
    
    [self shareInstance].uSysNo = dic[@"uSysNo"];
    
    [self shareInstance].uRegistTime = dic[@"uRegistTime"];
    [self shareInstance].res_desc = dic[@"res_desc"];
    [self shareInstance].res_num = (NSInteger)dic[@"res_num"];
    [self shareInstance].uPhone = dic[@"uPhone"];
    
    NSInteger uSex;
    if (dic[@"uSex"] == nil ||  [dic[@"uSex"] isEqual:[NSNull null]]) {
        uSex = 0;
    } else {
        uSex = [dic[@"uSex"] integerValue];
    }
    [self shareInstance].uSex = uSex;

    
    
    if (kObjectIsNil(dic) || dic[@"res_num"] == nil || [dic[@"res_num"] integerValue] != 0) {
        
        // 是否登录   YES = 登录
        [self shareInstance].isLogin = NO;
    } else {
        [self shareInstance].isLogin = YES;
    }
    
}


// 删除内存中的用户数据
+ (void)removeUserInfoModel {
    
    [YHUserInfo shareInstance].uId = 0;
    [YHUserInfo shareInstance].uCarBrand = @"";
    [YHUserInfo shareInstance].uNickname = @"";
    [YHUserInfo shareInstance].uHeadUrl = @"";
    [YHUserInfo shareInstance].res_code = 0;
    [YHUserInfo shareInstance].uCarType = @"";
    [YHUserInfo shareInstance].terminaType = 0;
    [YHUserInfo shareInstance].uSysNo = @"";
    [YHUserInfo shareInstance].uRegistTime = @"";
    [YHUserInfo shareInstance].res_desc = @"";
    [YHUserInfo shareInstance].res_num = 0;
    [YHUserInfo shareInstance].uPhone = nil;
    [YHUserInfo shareInstance].uSex = 0;
    
    [YHUserInfo shareInstance].isLogin = NO;
}



@end







