//
//  SearchModel.h
//  YouCheLian
//
//  Created by Mike on 16/3/2.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject
/// 商家id
@property (nonatomic, strong) NSNumber *ID;
/// 商家名称
@property (nonatomic, copy) NSString *merchName;
/// 缩略图url
@property (nonatomic, copy) NSString *imgUrl;
/// 营业时间
@property (nonatomic, copy) NSString *worktime;
/// 电话
@property (nonatomic, copy) NSString *mobile;
/// 距离
@property (nonatomic, copy) NSString *distance;
/// 商家地址
@property (nonatomic, copy) NSString *address;
/// 好评率
@property (nonatomic, strong) NSNumber *goodNum;

@end
