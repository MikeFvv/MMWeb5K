//
//  MeModel.m
//  YouCheLian
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "MeModel.h"

@implementation MeModel

+(instancetype)mineModel:(NSDictionary *)dict{
    return  [[self alloc]initWithDict:dict];
}




-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        /**
         *  这个地方如果用KVC 的话有局限性，因为他都是一一对应的，少一个都不行
         */
        //[self setValuesForKeysWithDictionary:dict];
        self.title = dict[@"title"];
        self.imageName = dict[@"image"];
    }
    return self;
}
@end
