//
//  ReleaseGroupViewController.h
//  YouCheLian
//
//  Created by Mike on 16/3/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "BaseViewController.h"
#import "ReleaseGroupModel.h"

@class ReleaseGroupViewController;

@protocol ReleaseGroupViewControllerDelegate <NSObject>

- (void)releaseGroupViewControllerWithModel:(ReleaseGroupModel *)model;

@end

@interface ReleaseGroupViewController : BaseViewController

@property (nonatomic,weak) id<ReleaseGroupViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *dataArray;

@end
