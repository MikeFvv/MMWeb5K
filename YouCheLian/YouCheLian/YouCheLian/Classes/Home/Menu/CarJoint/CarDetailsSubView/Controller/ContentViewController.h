//
//  ContentViewController.h
//  motoronline
//
//  Created by Mike on 16/1/30.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import "BaseViewController.h"

@protocol ContentViewControllerDelegate <NSObject>

-(void)downRefreshContent;

@end


@interface ContentViewController : BaseViewController

@property(nonatomic, strong) UIWebView *webView;
// html 字符串
@property(nonatomic, copy) NSString *htmlStr;

@property (nonatomic,weak) id<ContentViewControllerDelegate> delegate;
@end
