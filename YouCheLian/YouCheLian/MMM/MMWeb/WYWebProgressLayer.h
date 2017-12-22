
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#define MMSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width


@interface WYWebProgressLayer : CAShapeLayer

+ (instancetype)layerWithFrame:(CGRect)frame;

- (void)finishedLoad;
- (void)startLoad;

- (void)closeTimer;

@end
