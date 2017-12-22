//
//  UsedCarInfoCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UsedCarModel;

@interface UsedCarInfoCell : UITableViewCell

@property(nonatomic,strong) UsedCarModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
