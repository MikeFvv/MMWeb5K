//
//  CarShopInfoCell.h
//  motoronline
//
//  Created by Mike on 16/1/26.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CarShopInfoCellDelegate <NSObject>

@optional
-(void)clickCarGoodsAction:(UITapGestureRecognizer *)tap;
-(void)clickShopAction:(UITapGestureRecognizer *)tap;

@optional
-(void)clickcontactBtnAction:(UIButton *)btn;

@end


@class CarShopDetailsModel;

@interface CarShopInfoCell : UITableViewCell

@property(nonatomic,strong) CarShopDetailsModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<CarShopInfoCellDelegate> delegate;

@end
