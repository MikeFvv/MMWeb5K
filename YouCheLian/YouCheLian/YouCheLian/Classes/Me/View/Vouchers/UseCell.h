//
//  GoodsCell.h
//  YouCheLian
//
//  Created by Mike on 15/11/27.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VouchersDataListModel.h"

@interface UseCell : UITableViewCell

@property(nonatomic,strong) VouchersDataListModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
