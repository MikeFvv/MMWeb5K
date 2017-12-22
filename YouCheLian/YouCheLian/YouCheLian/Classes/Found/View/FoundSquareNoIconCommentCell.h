//
//  FoundSquareNoIconCommentCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/19.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoundSquareCommentCell.h"

@class FoundSquareModel,FoundDetailsModel;

@interface FoundSquareNoIconCommentCell : UITableViewCell

@property (nonatomic,strong) FoundDetailsModel *dataModel;

@property (weak, nonatomic) IBOutlet UIButton *commentNumBtn;

@property (weak, nonatomic) IBOutlet UIButton *upvoteNumBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property(nonatomic,strong) FoundSquareModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) id<FoundSquareCommentCellDelegate> delegate;

@end
