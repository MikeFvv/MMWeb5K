//
//  HMSettingCell.h
//  网易彩票
//
//  Created by Apple on 15/7/12.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingItem;
@interface SettingCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong) SettingItem *item;
/**
 *  是否显示分割线 YES:隐藏 NO:显示
 */
@property(nonatomic,assign ) BOOL hideLine;
@end
