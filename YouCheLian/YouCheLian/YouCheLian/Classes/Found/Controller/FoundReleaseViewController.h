//
//  FoundReleaseViewController.h
//  YouCheLian
//
//  Created by Mike on 16/3/17.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "BaseViewController.h"

@protocol FoundReleaseViewControllerDelegate <NSObject>

- (void)foundReleaseViewControllerReleaseSucceed;

@end

@interface FoundReleaseViewController : BaseViewController

@property (nonatomic,weak) id<FoundReleaseViewControllerDelegate> delegate;

@end
