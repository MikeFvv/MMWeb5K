//
//  ReleaseBrandViewController.h
//  YouCheLian
//
//  Created by Mike on 16/3/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "BaseViewController.h"
#import "ReleaseGroupModel.h"


@protocol ReleaseBrandViewControllerDelegate <NSObject>

- (void)ReleaseBrandViewControllerWithModel:(ReleaseGroupModel *)model;

@end

@interface ReleaseBrandViewController : BaseViewController

@property (nonatomic,weak) id<ReleaseBrandViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *dataArray;

@end
