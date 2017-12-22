//
//  ReleaseGroupModel.m
//  YouCheLian
//
//  Created by Mike on 16/3/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ReleaseGroupModel.h"

@implementation ReleaseGroupModel

/**
 *  返回所有应用信息数据
 */
+(NSArray *)GetmodelDataWithPlistFileName:(NSString *) fileName {
    
    return [ReleaseGroupModel mj_objectArrayWithFilename:fileName];
}

@end
