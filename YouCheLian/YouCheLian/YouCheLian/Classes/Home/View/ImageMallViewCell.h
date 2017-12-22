//
//  ImageMallViewCell.h
//  YouCheLian
//
//  Created by Mike on 15/12/14.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataListModel.h"

@interface ImageMallViewCell : UITableViewCell

@property (nonatomic, strong) DataListModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
