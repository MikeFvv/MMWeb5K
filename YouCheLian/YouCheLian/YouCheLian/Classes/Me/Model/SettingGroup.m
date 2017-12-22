//
//  HMSettingGroup.m
//  网易彩票
//
//  Created by Apple on 15/7/12.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "SettingGroup.h"

@implementation SettingGroup

+(instancetype)groupWithItems:(NSArray *)items{
    SettingGroup *group = [[self alloc] init];
    group.items = items;
    return group;
}
@end
