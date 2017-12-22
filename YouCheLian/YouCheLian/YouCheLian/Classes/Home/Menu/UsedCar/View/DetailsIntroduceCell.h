//
//  DetailsIntroduceCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UsedCarModel;
@interface DetailsIntroduceCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong) UsedCarModel *model;

@end
