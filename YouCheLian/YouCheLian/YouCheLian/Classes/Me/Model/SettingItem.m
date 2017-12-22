//
//  SettingItem.m
//  YouCheLian
//
//  Created by Mike on 15/11/23.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "SettingItem.h"

@implementation SettingItem
+(instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon{
    SettingItem *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    return item;
}

+(instancetype)itemWithTitle:(NSString *)title{
   return [self itemWithTitle:title icon:nil];
}

+(instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle{
    SettingItem *item = [self itemWithTitle:title icon:nil];
    item.subTitle = subTitle;
    return item;
}


- (CGFloat)cellHeight
{
    return _cellHeight>0.0f?_cellHeight:44;
}

@end
