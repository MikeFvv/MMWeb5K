//
//  MeSecondCarCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/28.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UsedCarModel.h"

@class MeSecondCarCell;
@protocol MeSecondCarCellDelegate <NSObject>

- (void)meSecondCarCellDidTopBtnClick:(MeSecondCarCell *)cell;
- (void)meSecondCarCellDidEditBtnClick:(MeSecondCarCell *)cell;
- (void)meSecondCarCellDidDeleteBtnClick:(MeSecondCarCell *)cell;


@end

@interface MeSecondCarCell : UITableViewCell

@property (nonatomic, weak) id<MeSecondCarCellDelegate> delegate;

@property (nonatomic, strong) UsedCarModel *model;

@end
