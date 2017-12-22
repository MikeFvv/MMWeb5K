//
//  DataListModel.h
//  CheLunShiGuang
//
//  Created by Mike on 15/10/31.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 首页焦点广告图
@interface DataListModel : NSObject

/// 图片url
@property (nonatomic, copy) NSString *imagUrl;
/// 内容
@property (nonatomic, copy) NSString *content;
/// url跳转
@property (nonatomic, copy) NSString *linkUrl;


+(instancetype)appWithDict:(NSDictionary *)dict;

-(instancetype)initWithDict:(NSDictionary *)dict;


@end
