//
//  HomeDiscountCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeDiscountModel;

@interface HomeDiscountCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) HomeDiscountModel *model;

@end
