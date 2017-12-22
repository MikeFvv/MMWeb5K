//
//  GuidePages.h
//  WheelTime
//
//  Created by Mike on 16/1/18.
//  Copyright © 2016年 微微. All rights reserved.
//

#import <UIKit/UIKit.h>

// 引导页类
@interface GuidePages : UIView

@property (nonatomic, strong) NSArray *imageDatas;
@property (nonatomic, copy) void (^buttonAction)();

- (instancetype)initWithImageDatas:(NSArray *)imageDatas completion:(void (^)(void))buttonAction;

@end
