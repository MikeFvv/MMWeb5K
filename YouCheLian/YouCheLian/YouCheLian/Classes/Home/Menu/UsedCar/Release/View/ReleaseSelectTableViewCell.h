//
//  ReleaseSelectTableViewCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ReleaseBaseTableViewCell.h"

@interface ReleaseSelectTableViewCell : ReleaseBaseTableViewCell


@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
