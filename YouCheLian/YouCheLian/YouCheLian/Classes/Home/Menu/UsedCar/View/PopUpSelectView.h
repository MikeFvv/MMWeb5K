//
//  FSOptionalAddStockAlertView.h
//  Finansir
//
//  Created by nobel on 16/1/4.
//  Copyright © 2016年 Finansir. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopUpSelectView;
@protocol PopUpSelectViewDelegate <NSObject>

- (void)PopUpSelectViewDelegate:(PopUpSelectView *)view index:(NSInteger)index;

@end

@interface PopUpSelectView : UIView

@property (nonatomic, weak) id<PopUpSelectViewDelegate>delegate;


- (void)showAlertViewWithTitle:(NSString *)title1 title2:(NSString *)title2;

@end
