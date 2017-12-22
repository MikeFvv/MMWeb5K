//
//  FoundActivityCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActListModel;

@interface FoundActivityCell : UITableViewCell


@property(nonatomic,strong) ActListModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
