//
//  UsedCarCommentCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UsedCarCommentModel;

@interface UsedCarCommentCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong) UsedCarCommentModel *model;

@end
