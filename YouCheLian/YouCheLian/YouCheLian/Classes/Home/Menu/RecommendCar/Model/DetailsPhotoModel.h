//
//  DetailsPhotoModel.h
//  motoronline
//
//  Created by Mike on 16/1/25.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailsPhotoModel : NSObject

///  id
@property (nonatomic, assign) NSInteger imgId;
/// 图片标题
@property (nonatomic, copy) NSString *imgTitle;
/// 图片url
@property (nonatomic, copy) NSString *imgUrl;


@end
