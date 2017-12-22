//
//  FoundShareViewController.h
//  YouCheLian
//
//  Created by Mike on 16/3/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ShareViewController.h"

@interface FoundShareViewController : ShareViewController

// 要分享的Url
@property (nonatomic, copy) NSString *path;

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, copy) NSString *descStr;

@property (nonatomic, strong) UIImage *image;

@end
