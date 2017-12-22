//
//  CarCommentCell.h
//  motoronline
//
//  Created by Mike on 16/1/26.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CarCommentModel;

@protocol CarCommentCellDelegate <NSObject>

- (void)carCommentCellCell:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imagArray:(NSArray *)imagArray;

@end

@interface CarCommentCell : UITableViewCell

@property(nonatomic,strong) CarCommentModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) id<CarCommentCellDelegate> delegate;
@end
