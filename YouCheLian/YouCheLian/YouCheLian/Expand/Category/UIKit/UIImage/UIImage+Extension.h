//
//  UIImage+Extension.h
//  
//
//  Created by Mike on 15/6/12.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/// 执行图片下载
//+(UIImage *)getImageFromURL:(NSString *)fileURL;

+ (UIImage*) imageWithName:(NSString *) imageName;
+ (UIImage*) resizableImageWithName:(NSString *)imageName;
- (UIImage*) scaleImageWithSize:(CGSize)size;
@end
