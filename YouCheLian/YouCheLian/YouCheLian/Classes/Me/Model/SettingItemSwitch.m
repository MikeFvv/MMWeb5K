//
//  SettingItemSwitch.m
//  YouCheLian
//
//  Created by Mike on 15/11/23.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "SettingItemSwitch.h"

@implementation SettingItemSwitch

- (void)setOn:(BOOL)on{
    _on = on;
    
    [UserDefaultsTools setBool:on forKey:self.title];

}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];

    _on = [UserDefaultsTools boolForKey:title];
    
}
@end
