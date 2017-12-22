//
//  ShareBtn.m
//  WheelTime
//
//  Created by Mike on 16/1/18.
//  Copyright © 2016年 微微. All rights reserved.
//

#import "ShareBtn.h"


#define imageWidth 60
#define titleHeight 20

@implementation ShareBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGRect)titleRectForContentRect:(CGRect)contentRect{

    return CGRectMake(0, contentRect.size.height - titleHeight, contentRect.size.width, titleHeight);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake((contentRect.size.width - imageWidth) / 2, (contentRect.size.height - imageWidth - titleHeight) / 2, imageWidth, imageWidth);
}

@end
