//
//  UsedCarCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/5.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsedCarModel.h"

@interface UsedCarCell : UITableViewCell

@property(nonatomic,strong) UsedCarModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
