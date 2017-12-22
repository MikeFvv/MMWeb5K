//
//  GetUrlString.m
//  YouCheLian
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "GetUrlString.h"


//************************ 开发环境 ************************
//#define kYHHttp @"http://www.yholink.com:8088/api.aspx"   // 优车联App
//#define kUrlShopWeb @"http://www.yholink.com:8087/index/index.html"   // 优车联商城
//#define kUrlNewCar @"http://www.yholink.com:8087/newpage/new.html"    // 新车
//#define kUrlBoutiqueWeb @"http://www.yholink.com:8087/newpage/jph.html"  // 精品汇
//#define kUrlLoginWeb @"http://www.yholink.com:8087/shop/checklogin.aspx?url="  // 进入商城检索用的
//#define kUrlBuyWeb @"http://www.yholink.com:8087/newpage/confimorder.aspx"  // 购买
//
//#define kShoppingCart @"http://www.yholink.com:8087/shop/cart.aspx"  // 购物车
//
//#define kUrlCarGroup  @"http://www.yholink.com:8087/shop/happ/car_joint.html"//智能车联
//
//#define kUrlCarGroupShare  @"http://www.yholink.com:8087/shop/happ/productShare.html"//智能车联分享
//
//#define kUrlBrandAct  @"http://www.yholink.com:8087/shop/happ/brandactivities.html"//优惠活动
//
//#define kUrlYouBao  @"http://www.yholink.com:8083/html/default.htm"//优宝
//// 优豆  跳转时需带上登录参数
//#define kUrlYouDou @"http://www.yholink.com:8087/shop/happ/good_beans.html"
//
////置顶服务购买
//#define kUrlBuyTop @"http://www.yholink.com:8087/shop/happ/payment.html"
//
////新车分享查看URL
//#define kUrlNewCarShare @"http://www.yholink.com:8087/shop/happ/NewMotoShare.html"






//************************ 正式环境 商业版 ************************
#define kYHHttp @"http://www.yholink.com:8086/api.aspx"   // 优车联App
#define kUrlShopWeb @"http://www.yholink.com:8081/index/index.html"   // 优车联商城
#define kUrlNewCar @"http://www.yholink.com:8081/newpage/new.html"    // 新车
#define kUrlBoutiqueWeb @"http://www.yholink.com:8081/newpage/jph.html"  // 精品汇
#define kUrlLoginWeb @"http://www.yholink.com:8081/shop/checklogin.aspx?url="  // 进入商城检索用的
#define kUrlBuyWeb @"http://www.yholink.com:8081/newpage/confimorder.aspx"  // 购买

#define kShoppingCart @"http://www.yholink.com:8081/shop/cart.aspx"  // 购物车

#define kUrlCarGroup  @"http://www.yholink.com:8081/shop/happ/car_joint.html"//智能车联

#define kUrlCarGroupShare  @"http://www.yholink.com:8081/shop/happ/productShare.html"//智能车联分享

#define kUrlBrandAct  @"http://www.yholink.com:8081/shop/happ/brandactivities.html"//优惠活动

#define kUrlYouBao  @"http://www.yholink.com:8082/html/default.htm"//优宝
// 优豆  跳转时需带上登录参数
#define kUrlYouDou @"http://www.yholink.com:8081/shop/happ/good_beans.html"

//置顶服务购买
#define kUrlBuyTop @"http://www.yholink.com:8081/shop/happ/payment.html"

//新车分享查看URL
#define kUrlNewCarShare @"http://www.yholink.com:8081/shop/happ/NewMotoShare.html"




// #import "HomeServiceModel.h"
@implementation GetUrlString

+(GetUrlString *)sharedManager{
    static GetUrlString *shareUrl = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareUrl = [[self alloc]init];
    });
    return shareUrl;
}
/// 优车联App
-(NSString *)urlYoLinkWebHttp {
    NSString *urlStr = [NSString stringWithFormat:kYHHttp];
    return urlStr;
}

/// 优车联商城
-(NSString *)urlWithMallWebData {
    NSString *urlStr = [NSString stringWithFormat:kUrlShopWeb];
    return urlStr;
}

/// 发现
-(NSString *)urlWithFoundWebData {
//    NSString *urlStr = [NSString stringWithFormat:@"http://112.74.132.2:8082/jctp.html"];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.yholink.com:8082/html"];
    
    return urlStr;
}

/// 买车 新车/特惠活动 BuyCar
-(NSString *)urlBuyCarWeb {
    NSString *urlStr = [NSString stringWithFormat:kUrlNewCar];
    return urlStr;
}

/// 精品汇
-(NSString *)urlBoutiqueWeb {
    NSString *urlStr = [NSString stringWithFormat:kUrlBoutiqueWeb];
    return urlStr;
}
/// 购买
-(NSString *)urlBuyWeb {
    NSString *urlStr = [NSString stringWithFormat:kUrlBuyWeb];
    return urlStr;
}

/// 购物车
-(NSString *)urlShoppingCartWeb {
    NSString *urlStr = [NSString stringWithFormat:kShoppingCart];
    return urlStr;
}
/// 检索
-(NSString *)urlLoginWeb {
    NSString *urlStr = [NSString stringWithFormat:kUrlLoginWeb];
    return urlStr;
}
/// 智能车联
-(NSString *)urlCarGroup {
    NSString *urlStr = [NSString stringWithFormat:kUrlCarGroup];
    return urlStr;
}

/// 智能车联分享
-(NSString *)urlCarGroupShare {
    NSString *urlStr = [NSString stringWithFormat:kUrlCarGroupShare];
    return urlStr;
}
/// 优惠活动
-(NSString *)urlBrandAct {
    NSString *urlStr = [NSString stringWithFormat:kUrlBrandAct];
    return urlStr;
}
/// 优宝
-(NSString *)urlYouBao {
    NSString *urlStr = [NSString stringWithFormat:kUrlYouBao];
    return urlStr;
}

/// 我的优豆
-(NSString *)urlYouDou {
    NSString *urlStr = [NSString stringWithFormat:kUrlYouDou];
    return urlStr;
}

/// 购买置顶
-(NSString *)urlBuyTop {
    NSString *urlStr = [NSString stringWithFormat:kUrlBuyTop];
    return urlStr;
}

/// 新车分享查看
-(NSString *)urlNewCarShare {
    NSString *urlStr = [NSString stringWithFormat:kUrlNewCarShare];
    return urlStr;
}

@end










