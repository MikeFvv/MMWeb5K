//
//  HomeMenuCell.h
//  YouCheLian
//
//  Created by Mike on 15/11/10.
//  Copyright (c) Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  HomeMenuCellDelegate <NSObject>
@optional
-(void)homeMenuCellClick:(long)sender;

@end
@interface HomeMenuCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView menuArray:(NSArray *)menuArray;
@property(nonatomic, weak)id <HomeMenuCellDelegate >delegate;

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menu:(NSArray *)menu;

+ (instancetype)cellWithTableViewNo:(UITableView *)tableView menuArray:(NSArray *)menuArray;


@end
