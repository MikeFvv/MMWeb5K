//
//  MePaymentCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/24.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderInfoModel;

@protocol MePaymentCellDelegate <NSObject>

- (void)onClickViewTagDelegate:(NSInteger)index;

@end

@interface MePaymentCell : UITableViewCell

@property (nonatomic, strong) OrderInfoModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<MePaymentCellDelegate> delegate;

@end
