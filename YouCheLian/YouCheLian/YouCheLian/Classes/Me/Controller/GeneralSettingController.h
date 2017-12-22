//
//  GeneralSettingController.h
//  YouCheLian
//
//  Created by Mike on 15/11/19.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingGroup.h"
#import "SettingItem.h"
#import "SettingCell.h"
#import "SettingItemArrow.h"
#import "SettingItemSwitch.h"

// 通用设置 基类
@interface GeneralSettingController : UITableViewController

/**
 *  组数组(元素类型：SettingGroup)
 */
@property(nonatomic,strong,readonly) NSMutableArray *groups;

@end
