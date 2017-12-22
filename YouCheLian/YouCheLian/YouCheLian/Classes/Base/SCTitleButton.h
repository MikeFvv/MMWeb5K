//
//  SWTitleButton.h
//  SimpleWeiBo
//
//  Created by Jason on 14/12/11.
//  Copyright (c) 2014年 Jason’s Application House. All rights reserved.
//  可把图片调整至文字右侧,子控件变化时自适应大小,字体默认黑色,粗体,20号

#import <UIKit/UIKit.h>


///  自定义
@interface SCTitleButton : UIButton
/**是否把图片移动至右侧*/
@property (nonatomic, assign) BOOL moveImageToRight;
/**字体颜色*/
@property (nonatomic, strong) UIColor *titleColor;
/**字体*/
@property (nonatomic, strong) UIFont *titleFont;
@end
