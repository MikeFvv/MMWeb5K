//
//  CarJointIntroduceCellTableViewCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/4.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarDetailsModel;

@interface CarJointIntroduceCellTableViewCell : UITableViewCell

@property(nonatomic,strong) CarDetailsModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
