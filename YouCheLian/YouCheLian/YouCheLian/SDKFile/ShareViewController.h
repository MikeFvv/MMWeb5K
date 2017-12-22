//
//  ShareViewController.h
//  WheelTime
//
//  Created by Mike on 16/1/18.
//  Copyright © 2016年 微微. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface ShareViewController : UIViewController


- ( UIImage *)imageWithImageSimple:( UIImage *)image scaledToSize:( CGSize )newSize;

- (void)show;

@end
