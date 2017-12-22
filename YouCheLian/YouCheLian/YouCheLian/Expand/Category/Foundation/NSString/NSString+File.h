//
//  NSString+File.h
//  黑马微博
//
//  Created by apple on 14-7-25.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (File)
/**
 *  计算某个文件\文件夹的大小
 *
 *  @param file 文件\文件夹的路径
 */
- (long long)fileSize;


/**
 *  转为documents下的子文件夹
 */
@property (nonatomic,copy,readonly) NSString *documentsSubFolder;

@end
