//
//  MeSystemMessageController.h
//  YouCheLian
//
//  Created by Mike on 16/3/23.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "BaseViewController.h"

@class MeSystemMessageController;
@protocol MeSystemMessageControllerDelegate <NSObject>

- (void)meSystemMessageController:(MeSystemMessageController *)VC didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MeSystemMessageController : BaseViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) id<MeSystemMessageControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *dataArray;


@end
