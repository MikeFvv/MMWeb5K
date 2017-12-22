//
//  FoundCarContentViewController.h
//  YouCheLian
//
//  Created by Mike on 16/3/5.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "BaseViewController.h"

@protocol FoundCarContentViewControllerDelegate <NSObject>

-(void)downRefreshContent;

@end

@interface FoundCarContentViewController : BaseViewController

@property(nonatomic, strong) UIWebView *webView;
// html 字符串
@property(nonatomic, copy) NSString *htmlStr;

@property (nonatomic, copy) NSString *carId;
@property (nonatomic, copy) NSString *type;

@property (nonatomic,weak) id<FoundCarContentViewControllerDelegate> delegate;

@end
