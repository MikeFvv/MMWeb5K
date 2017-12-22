//
//  GetUrlString.h
//  YouCheLian
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>


/// 所有的 url 都放这里
@interface GetUrlString : NSObject
/**
 *  获取URL的单例
 */
+(GetUrlString *)sharedManager;

/// 优车联App
-(NSString *)urlYoLinkWebHttp;

/// 友浩商城
-(NSString *)urlWithMallWebData;

/// 发现
-(NSString *)urlWithFoundWebData;

/// 买车 新车/特惠活动 BuyCar
-(NSString *)urlBuyCarWeb;

/// 精品汇
-(NSString *)urlBoutiqueWeb;
/// 购物车
-(NSString *)urlShoppingCartWeb;
//购买
-(NSString *)urlBuyWeb;
//商城检索
-(NSString *)urlLoginWeb;
/// 智能车联
-(NSString *)urlCarGroup;
/// 智能车联分享
-(NSString *)urlCarGroupShare;
/// 优惠活动
-(NSString *)urlBrandAct;
/// 优宝
-(NSString *)urlYouBao;

/// 我的优豆
-(NSString *)urlYouDou;

///购买置顶
-(NSString *)urlBuyTop;
/// 新车分享查看
-(NSString *)urlNewCarShare;



@end








