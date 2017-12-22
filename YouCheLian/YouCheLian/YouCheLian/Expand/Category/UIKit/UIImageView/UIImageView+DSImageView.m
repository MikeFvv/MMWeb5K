//
//  UIImageView+DSImageView.m
//  YouCheLian
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "UIImageView+DSImageView.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (DSImageView)
- (void)ww_setImageWithString:(NSString *)url{
    
    [self sd_setImageWithURL:[NSURL URLWithString:url]];
    
}

- (void)ww_setImageWithString:(NSString *)url wihtImgName:(NSString *)imgName {
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:imgName]];
    
}

@end
