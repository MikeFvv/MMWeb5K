//
//  FoundCarIntroduceCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/5.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoundCarDetailsModel;
@interface FoundCarIntroduceCell : UITableViewCell
@property(nonatomic,strong) FoundCarDetailsModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
