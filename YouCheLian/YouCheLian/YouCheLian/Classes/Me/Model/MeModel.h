//
//  MeModel.h
//  YouCheLian
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeModel : NSObject
/**
 *  标题
 */
@property (nonatomic ,copy)NSString *title;
/**
 *  图片名
 */
@property (nonatomic ,copy)NSString *imageName;
+(instancetype)mineModel:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
