//
//  AdsTableCell.h
//  YouCheLian
//
//  Created by Mike on 15/12/5.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdsTableCellDelegate <NSObject>

- (void)didAdsSelectItemAtIndex:(NSInteger)index;

@end

/// 无限图片轮播器
@interface AdsTableCell : UITableViewCell

@property (nonatomic, strong) NSArray *imgArray;

@property(nonatomic, weak) id<AdsTableCellDelegate >delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
