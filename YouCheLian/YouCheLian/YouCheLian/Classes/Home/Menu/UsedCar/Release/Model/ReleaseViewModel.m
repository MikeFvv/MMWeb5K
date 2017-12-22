//
//  ReleaseViewModel.m
//  YouCheLian
//
//  Created by Mike on 16/3/8.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ReleaseViewModel.h"
#import <MJExtension.h>

@implementation ReleaseViewModel

/**
 *  返回所有应用信息数据
 */
+(NSArray *)modelData {

    return [ReleaseViewModel mj_objectArrayWithFilename:@"ReleaseView.plist"];
}


@end
