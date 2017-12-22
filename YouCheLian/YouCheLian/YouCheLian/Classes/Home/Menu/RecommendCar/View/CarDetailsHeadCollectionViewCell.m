//
//  CarDetailsHeadCollectionViewCell.m
//  motoronline
//
//  Created by Mike on 16/2/18.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import "CarDetailsHeadCollectionViewCell.h"

@interface CarDetailsHeadCollectionViewCell()


@end

@implementation CarDetailsHeadCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
//    _imagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight * 0.39)];
    self.imagView.image = [UIImage imageNamed:@"image_placeholder"];
    [self.imagView setClipsToBounds:YES];
    [self.imagView setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)setImagStr:(NSString *)imagStr {
    _imagStr = imagStr;
    [self.imagView ww_setImageWithString:imagStr wihtImgName:@"image_placeholder"];
    
}

@end
