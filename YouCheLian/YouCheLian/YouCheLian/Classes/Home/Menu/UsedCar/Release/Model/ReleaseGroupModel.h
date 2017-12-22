//
//  ReleaseGroupModel.h
//  YouCheLian
//
//  Created by Mike on 16/3/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReleaseGroupModel : NSObject

/*
 用户名
 */
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *ID;


+(NSArray *)GetmodelDataWithPlistFileName:(NSString *) fileName;

@end
