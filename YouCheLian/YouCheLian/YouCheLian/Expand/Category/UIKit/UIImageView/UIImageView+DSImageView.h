//
//  UIImageView+DSImageView.h
//  YouCheLian
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

// 赋值图片时用的
@interface UIImageView (DSImageView)
// 请求url 图片
- (void)ww_setImageWithString:(NSString *)url;

/// 请求url 图片 ， 如没有， 使用占位图片代替
/// url  url地址
/// imgName 占位图片
- (void)ww_setImageWithString:(NSString *)url wihtImgName:(NSString *)imgName;
@end
