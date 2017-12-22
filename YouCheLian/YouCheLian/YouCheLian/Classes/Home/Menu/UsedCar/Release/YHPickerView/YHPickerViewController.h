//
//  YHPickerViewController.h
//  地区选择器
//
//  Created by Mike on 16/3/10.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YHPickerViewControllerDelegate <NSObject>

- (void)pickerViewControllerDidClickSureBtnWithRow1:(NSInteger)row1 andRow2:(NSInteger)row2 andRow3:(NSInteger)row3;

@optional
- (void)pickerViewControllerDisappear;

@end

@interface YHPickerViewController : UIViewController

@property (nonatomic, strong) id<YHPickerViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *dataArray;

- (void)show;

@end
