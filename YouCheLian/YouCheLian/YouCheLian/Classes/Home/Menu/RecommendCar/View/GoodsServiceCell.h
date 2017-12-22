//
//  GoodsServiceCell.h
//  motoronline
//
//  Created by Mike on 16/1/26.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsServiceCell : UITableViewCell

//数据模型数组
@property (nonatomic, strong) NSArray *dataModels;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
