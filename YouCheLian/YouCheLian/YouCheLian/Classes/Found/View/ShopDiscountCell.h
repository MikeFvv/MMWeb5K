//
//  ShopDiscountCell.h
//  YouCheLian
//
//  Created by Mike on 15/12/16.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VoucherModel;

@interface ShopDiscountCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) VoucherModel *model;

@end
