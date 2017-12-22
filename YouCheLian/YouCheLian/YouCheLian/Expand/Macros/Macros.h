//
//  Macros.h
//  YouCheLian
//
//  Created by Mike on 16/4/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#ifndef Macros_h
#define Macros_h



/************ app第一次开启标记 ************/
#define kFirstLaunched @"FirstLaunched"

// 引导页 通知名称
#define kNotificationEnter @"enter"





/************************** 设备 **************************/
/************ 数字 宽高 ************/
// 手机屏幕的宽高
#define kUIScreenWidth       [UIScreen mainScreen].bounds.size.width
#define kUIScreenHeight      [UIScreen mainScreen].bounds.size.height

/***  系统控件的默认高度  ***/
// 导航栏
#define kUINavHeight 64
#define kPopViewHeight 44
// 选项卡  工具栏
#define kUITabBarHeight 49

/************ iPhone的型号 ************/
#define IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height == 480)  // 宽 320
#define IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)  // 宽 320
#define IS_IPHONE6 ([[UIScreen mainScreen] bounds].size.height == 667)  // 宽 375
#define IS_IPHONE6_PLUS ([[UIScreen mainScreen] bounds].size.height == 736)  // 宽 414

/************  系统版本  ************/
/*** 是否为iOS7 ***/
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
/*** 是否为iOS8及以上系统 ***/
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
/*** 系统的版本号 ***/
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]



// 首页Head高度 比例 210
#define HomeHeadheight  0.314

// 首页高度 比例 100
#define HomeCellHeight  0.149

// 首页功能菜单高度
#define HomeMenuCellHeight 95.0
// 二手车详情head 高度比例
#define kHeadCellHeight 0.4

// 二手车 下拉菜单head高度
#define kHeadTitleHeight 45
// 发现 head 图片高度
#define kHeadImagHeight kUIScreenHeight * 0.450
// 发现 优惠车型 cell高度
#define DisCarCellHeight  kUIScreenHeight * 0.370  // 245

// 我的 head 高度
#define kMeHeadHeight 160

#define kNav_Back_CGRectMake CGRectMake(0, 0, 11, 21)
// 全局边距
#define kGlobalMargin 15


// ************************** 颜 色 **************************
// 导航栏头部颜色  灰白色
#define kNavColor [UIColor colorWithRed:0.973  green:0.976  blue:0.980 alpha:1]
// 控制器背景颜色
#define kViewControllerColor  [UIColor colorWithRed:0.922  green:0.925  blue:0.929 alpha:1]


// 全局颜色 绿色
#define kGlobalColorGreen [UIColor colorWithRed:0.137  green:0.706  blue:0.341 alpha:1]
// 深绿色  按钮 文字等使用
#define kColorDarkGreen [UIColor colorWithRed:0.106  green:0.580  blue:0.275 alpha:1]
// 绿色
#define kGreenColor [UIColor colorWithRed:0.141  green:0.702  blue:0.341 alpha:1]


// 全局字体颜色 黑色
#define kGlobalFontColor [UIColor colorWithRed:0.267  green:0.267  blue:0.267 alpha:1]
// 字体颜色 灰黑色
#define kFontColor [UIColor colorWithRed:0.192  green:0.200  blue:0.204 alpha:1]
// 全局 松花色、浅黄绿色
#define kGlobalColor [UIColor colorWithRed:0.588  green:0.776  blue:0.145 alpha:1]
// 淡灰黑色
#define kFontColorGray  [UIColor colorWithRed:0.604  green:0.604  blue:0.608 alpha:1]


// 淡灰白色 Cell 分隔色
#define kCellColorGray  [UIColor colorWithRed:0.416  green:0.420  blue:0.427 alpha:1]


// 系统浅灰色
#define kLightGrayColor  [UIColor lightGrayColor]




// section分区头部视图颜色
#define kSectionHeaderColor [UIColor colorWithRed:0.922  green:0.925  blue:0.929 alpha:1]
// 全局 Cell 分割线颜色  浅灰色
#define kLineBackColor [UIColor colorWithRed:0.863  green:0.871  blue:0.871 alpha:1]
// 全局 Cell 底部分割线颜色  淡灰色
#define kCellBottomView [UIColor colorWithRed:0.910  green:0.914  blue:0.918 alpha:1]

// Cell 选中样式颜色
#define kUITableViewCellSelectionStyleGray  UITableViewCellSelectionStyleGray





/****** 颜色(RGB) ******/
#define RGBA(r, g, b, a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define RGB(r, g, b)  RGBA(r, g, b, 1.0f)

#define RGB_S(r,g,b)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1];

/****** 颜色(0xFFFFFF) ******/
#define HEX_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HEX_RGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

// 随机色
#define kRandomColor FSColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//首页tarbar栏文字颜色
#define navigationBarColor [UIColor colorWithRed:0.561  green:0.765  blue:0.129 alpha:1]
#define separaterColor RGB(200, 199, 204)



// ************ 字 体 大 小 ************


// 导航栏title字体大小
#define kNavTitleFont18 [UIFont systemFontOfSize:18.0f]


/************  用户信息  ************/
// 商品收藏
#define goodsCollStr [NSString stringWithFormat:@"%@GoodsCollect", [YHUserInfo shareInstance].uPhone]
#define goodsCollNum [NSString stringWithFormat:@"%@GoodsCollNum", [YHUserInfo shareInstance].uPhone]


// 商家收藏
#define ShopColStr [NSString stringWithFormat:@"%@ShopColStr", [YHUserInfo shareInstance].uPhone]
// 商家收藏数量
#define ShopCollNum [NSString stringWithFormat:@"%@ShopCollNum", [YHUserInfo shareInstance].uPhone]




// *******************************

// 原生弹出信息
#define ALERT(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show]


// **************************  Other **************************

//当前城市
#define  kCityName  @"cityName"

// 评论字符限制
#define kCharNum 200

// 搜索文件
#define SearchHistoryPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"hisDatas.data"]

// G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

// IOS版本
#define kIOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

// 销毁打印
#define kDealloc MyLog(@"=========%@彻底销毁了========",[self class])

// 是否为空对象
#define kObjectIsNil(__object)     ((nil == __object) || [__object isKindOfClass:[NSNull class]])
// 数组为空
#define kArrayIsEmpty(__array) ((__array==nil) || ([__array isKindOfClass:[NSNull class]]) || (array.count==0))


// **************************  Log **************************

// 日记输出宏
#ifdef DEBUG // 调试状态, 打开LOG功能
#define YHLog(...) NSLog(__VA_ARGS__)
#else  // 发布状态, 关闭LOG功能
#define YHLog(...)
#endif




/*** 判断设备室真机还是模拟器 ***/
#if TARGET_OS_IPHONE
// iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
// iPhone Simulator
#endif





#endif /* Macros_h */
