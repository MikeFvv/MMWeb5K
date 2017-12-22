//
//  HomeFocusModel.m
//  CheLunShiGuang
//
//  Created by Mike on 15/10/31.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "HomeFocusModel.h"
#import "DataListModel.h"

@implementation HomeFocusModel




+(instancetype)appWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {

        [self setValuesForKeysWithDictionary:dict];
        
        NSMutableArray *apps = [NSMutableArray array];
        for(NSDictionary *dict in self.dataList) {
            DataListModel *lowerList = [DataListModel appWithDict:dict];
            
            [apps addObject:lowerList];
        }
        // 重新赋值
        self.dataList = apps;
    }
    return self;
}


@end
