//
//  GroupTableViewCell.h
//  CheLunShiGuang
//
//  Created by Mike on 15/10/31.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupCollectionViewModel.h"

@protocol GroupTableViewCellDelegate <NSObject>

- (void)didMenuSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface GroupTableViewCell : UITableViewCell

/// 应用信息
@property(nonatomic,strong)NSArray *collArray;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<GroupTableViewCellDelegate> delegate;

@end
