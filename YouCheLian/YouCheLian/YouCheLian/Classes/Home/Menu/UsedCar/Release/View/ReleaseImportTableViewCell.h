//
//  ReleaseImportTableViewCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ReleaseBaseTableViewCell.h"

@interface ReleaseImportTableViewCell : ReleaseBaseTableViewCell

@property (weak, nonatomic) IBOutlet UITextField *contentTextFiled;

@property (nonatomic, strong) NSIndexPath *indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
