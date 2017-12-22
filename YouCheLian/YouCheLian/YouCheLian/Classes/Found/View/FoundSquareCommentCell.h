//
//  FoundSquareCommentCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/17.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FoundSquareModel,FoundDetailsModel;

@protocol FoundSquareCommentCellDelegate <NSObject>

- (void)foundSquareCommentCellCell:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imagArray:(NSArray *)imagArray;

@optional
- (void)FoundSquareCommentCellDidClickUpvoteNumBtn:(UIButton *)btn withModel:(FoundSquareModel*)model;

- (void)FoundSquareCommentCellDidClickDeleteBtn:(UIButton *)btn withModel:(FoundSquareModel*)model;

@end

@interface FoundSquareCommentCell : UITableViewCell

@property (nonatomic,strong) FoundDetailsModel *dataModel;

@property(nonatomic,strong) FoundSquareModel *model;

@property (weak, nonatomic) IBOutlet UIButton *commentNumBtn;

@property (weak, nonatomic) IBOutlet UIButton *upvoteNumBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<FoundSquareCommentCellDelegate> delegate;

@end
