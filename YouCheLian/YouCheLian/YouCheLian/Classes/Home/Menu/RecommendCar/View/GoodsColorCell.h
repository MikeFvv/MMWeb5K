//
//  GoodsColorCell.h
//  motoronline
//
//  Created by Mike on 16/1/26.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsColorCell : UITableViewCell

@property (nonatomic ,copy) NSString *selectInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
