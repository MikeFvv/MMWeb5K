//
//  ShopImageCell.h
//  YouCheLian
//
//  Created by Mike on 15/12/11.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopDetailsModel;

@protocol ShopImageCellDelegate <NSObject>

- (void)didViewSelectItemAtIndexPath;

- (void)collectBtnAction:(UIButton *)sender;

- (void)clickImageView;

@end

//block  店铺优惠
typedef void (^ShopImageBlock)();
//block  收藏
typedef void (^CollectBtnBlock)();


@interface ShopImageCell : UITableViewCell

@property(nonatomic,strong) ShopDetailsModel *model;

@property (strong, nonatomic)  UIImageView *imgUrlView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<ShopImageCellDelegate> delegate;

@property(nonatomic,assign) int iconCount;

@end
