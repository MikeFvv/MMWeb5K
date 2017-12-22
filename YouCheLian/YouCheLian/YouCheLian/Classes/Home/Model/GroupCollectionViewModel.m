//
//  GroupCollectionViewMode.m
//  CheLunShiGuang
//
//  Created by Mike on 15/11/1.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "GroupCollectionViewModel.h"
#import "MJExtension.h"

@interface GroupCollectionViewModel()



@end

@implementation GroupCollectionViewModel



/**
 *  返回所有应用信息数据
 */
+(NSArray *)modelData {
  
    NSMutableArray *apps = [GroupCollectionViewModel mj_objectArrayWithFilename:@"Main_Menu.plist"];
    return apps;
}

@end
