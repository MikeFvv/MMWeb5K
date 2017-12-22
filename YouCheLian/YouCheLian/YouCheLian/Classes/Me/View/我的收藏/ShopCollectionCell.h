//
//  GoodsCollectionCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/24.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopCollectionModel;
@interface ShopCollectionCell : UITableViewCell

@property (nonatomic, strong) ShopCollectionModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
