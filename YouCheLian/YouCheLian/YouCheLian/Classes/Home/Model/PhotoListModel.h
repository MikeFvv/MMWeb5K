//
//  PhotoListModel.h
//  CheLunShiGuang
//
//  Created by Mike on 15/11/3.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>


/// 云相片数据
@interface PhotoListModel : NSObject

/// 云图片Id(唯一)
@property (nonatomic, assign) int imageId;
/// 地址
@property (nonatomic, copy) NSString *address;
/// Gps时间
@property (nonatomic, copy) NSString *gpsTime;
/// 图片url
@property (nonatomic, copy) NSString *imagUrl;

@end
