//
//  MyModel.m
//  TableViewIndex
//
//  Created by Mike on 15/12/8.
//  Copyright © 2015年 微微. All rights reserved.
//

#import "MyModel.h"

@implementation MyModel


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
        self.ID = dict[@"ID"];
        
        self.name = dict[@"name"];
        //        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


@end
