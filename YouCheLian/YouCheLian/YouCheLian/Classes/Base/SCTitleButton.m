//
//  SWTitleButton.m
//  SimpleWeiBo
//
//  Created by Jason on 14/12/11.
//  Copyright (c) 2014年 Jason’s Application House. All rights reserved.
//

#import "SCTitleButton.h"

@interface UIView (SCTitleButton)
@property (nonatomic, assign) CGFloat x;
@end


@implementation SCTitleButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setUp];
         self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return self;
}

- (void)setUp {
    [self setTitle:@"测试" forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 图片是否在 button 右边
    if (self.moveImageToRight) {
//        self.titleLabel.x = self.imageView.x;
//        self.imageView.x = CGRectGetMaxX(self.titleLabel.frame);
        
        self.titleLabel.x = 0;
        self.imageView.x  = CGRectGetMaxX(self.titleLabel.frame) > 80 ? 80.0 : CGRectGetMaxX(self.titleLabel.frame) + 8;
    }
    // 设置字体颜色
    if (self.titleColor) {
        [self setTitleColor:self.titleColor forState:UIControlStateNormal];
    } else {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    // 设置字体大小
    self.titleLabel.font = self.titleFont ? self.titleFont : [UIFont boldSystemFontOfSize:18.0];
}

// 设置文字
- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self sizeToFit];
}
// 设置图片
- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self sizeToFit];
}
@end


@implementation UIView (SCTitleButton)

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x {
    return self.frame.origin.x;
}

@end
