//
//  FoundShopViewController.h
//  YouCheLian
//
//  Created by Mike on 16/3/16.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchModel;
@protocol FoundShopViewControllerDelegate <NSObject>

-(void)didSelectJumpFoundShopDelegateModel:(SearchModel *)model;

@end

@interface FoundShopViewController : UITableViewController

@property (nonatomic, weak) id<FoundShopViewControllerDelegate> delegate;

@end
