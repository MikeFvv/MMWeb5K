//
//  FSOptionalAddStockAlertView.m
//  Finansir
//
//  Created by nobel on 16/1/4.
//  Copyright © 2016年 Finansir. All rights reserved.
//

#import "PopUpSelectView.h"

#define kBtnHeight 50

static PopUpSelectView *alertView;
@interface PopUpSelectView ()<UITextFieldDelegate>
{
    CGFloat alertViewWidth;
    CGFloat alertViewHeight;
    UIView *alertView;
    
    UIButton *btn1;
    UIButton *btn2;
}

@end

@implementation PopUpSelectView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // 黑透明色蒙层
        UIView *BackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight)];
        BackView.backgroundColor = [UIColor blackColor];
        BackView.alpha = 0.3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmisBackgroundView)];
        [BackView addGestureRecognizer:tap];
        
        [self addSubview:BackView];
        
        alertViewWidth = kUIScreenWidth*0.65;
        alertViewHeight = kBtnHeight * 2;
        
        alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, alertViewHeight)];
        alertView.center = CGPointMake(kUIScreenWidth/2, kUIScreenHeight/2);
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.layer.cornerRadius = 6;
        alertView.clipsToBounds = YES;
        alertView.layer.borderColor = (__bridge CGColorRef _Nullable)(kGlobalColorGreen);
        alertView.layer.borderWidth = 0.5;
        [self addSubview:alertView];
        
        btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, kBtnHeight)];
//        [btn1 setTitle:@"摩托车信息发布" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn1.tag = 600;
        [btn1 addTarget:self action:@selector(alertBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:btn1];
        
        
        btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, kBtnHeight, alertViewWidth, kBtnHeight)];
//        [btn2 setTitle:@"电动车信息发布" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(alertBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn2.tag = 601;
        [alertView addSubview:btn2];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kBtnHeight, alertViewWidth, 1)];
        lineView.backgroundColor = kLineBackColor;
        [alertView addSubview:lineView];
    }
    return self;
}

#pragma mark - 移除视图
// 移除视图
- (void)dissmisBackgroundView
{
    [self removeFromSuperview];
}



- (void)alertBtnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(PopUpSelectViewDelegate: index:)]) {
        
        [self.delegate PopUpSelectViewDelegate:self index: sender.tag - 600];
    }
    // 移除视图
    [self dissmisBackgroundView];
}

- (void)showAlertViewWithTitle:(NSString *)title1 title2:(NSString *)title2
{
    [btn1 setTitle:title1 forState:UIControlStateNormal];
    [btn2 setTitle:title2 forState:UIControlStateNormal];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

@end
