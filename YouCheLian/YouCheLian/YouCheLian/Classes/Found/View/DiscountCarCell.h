//
//  DiscountCarCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/31.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiscountCarCellDelegate <NSObject>

- (void)didSelectedDiscountCarCell:(NSInteger)index;

@end

@interface DiscountCarCell : UITableViewCell

/// 应用信息
@property(nonatomic,strong)NSArray *cellArray;


+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<DiscountCarCellDelegate> delegate;


@end
