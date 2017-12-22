//
//  SettingItemArrow.m
//  YouCheLian
//
//  Created by Mike on 15/11/23.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "SettingItemArrow.h"

@implementation SettingItemArrow

+(instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon destVc:(Class)destVC{
    SettingItemArrow *item = [self itemWithTitle:title icon:icon];
    item.destVc = destVC;
    return item;
}

+(instancetype)itemWithTitle:(NSString *)title destVc:(Class)destVC{
    return [self itemWithTitle:title icon:nil destVc:destVC];
}

@end
