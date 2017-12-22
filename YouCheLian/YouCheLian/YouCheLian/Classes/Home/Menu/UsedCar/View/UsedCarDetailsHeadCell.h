//
//  UsedCarDetailsHeadCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UsedCarDetailsHeadCellDelegate <NSObject>

- (void)didHeaderImageAction;

@end

@class UsedCarModel;
@interface UsedCarDetailsHeadCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imagView;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong) UsedCarModel *model;

@property (nonatomic, weak) id<UsedCarDetailsHeadCellDelegate> delegate;

@end
