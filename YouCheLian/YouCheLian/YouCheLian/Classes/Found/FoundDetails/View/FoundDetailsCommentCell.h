//
//  FoundDetailsCommentCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/21.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoundCommentModel.h"


@class FoundDetailsCommentCell;
@protocol FoundDetailsCommentCellDelegate <NSObject>

- (void)FoundDetailsCommentCellDidClickDeleteBtn:(FoundDetailsCommentCell *)cell;

@end

@interface FoundDetailsCommentCell : UITableViewCell
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) FoundCommentModel *model;

@property (nonatomic, weak) id<FoundDetailsCommentCellDelegate> delegate;

@end
