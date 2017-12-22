//
//  ServiceListModel.h
//  YouCheLian
//
//  Created by Mike on 15/12/11.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceListModel : NSObject

// 服务的图标
@property (nonatomic, copy) NSString *ImgUrl;
// 服务名称
@property (nonatomic, copy) NSString *ServerName;
// 服务价格
@property (nonatomic, copy) NSString *Price;
// 扩展属性：1=保养，2=维修，3=美容，4=洗车
@property (nonatomic, assign) NSInteger Attribute;

@end
