//
//  ReleaseMultiImportTableViewCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/14.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ReleaseBaseTableViewCell.h"

@protocol ReleaseMultiImportTableViewCellDelegate <NSObject>

- (void)releaseMultiImportTableViewTextView:(UITextView *)textView CellChangeTextFieldText:(NSString *)text;

@end


@interface ReleaseMultiImportTableViewCell : ReleaseBaseTableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,weak) id<ReleaseMultiImportTableViewCellDelegate> delegate;

@end
