//
//  DataListModel.m
//  CheLunShiGuang
//
//  Created by Mike on 15/10/31.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "DataListModel.h"

@implementation DataListModel

/**
 *  快速创建一个模型对象
 *
 */
+(instancetype)appWithDict:(NSDictionary *)dict{
    // self:哪个类调用该方法，self就指向那个类
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.imagUrl = dict[@"imagUrl"];
        self.content = dict[@"context"];
        self.linkUrl = dict[@"linkUrl"];
        //        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


@end
