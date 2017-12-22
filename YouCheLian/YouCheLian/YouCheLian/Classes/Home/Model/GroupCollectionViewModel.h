//
//  GroupCollectionViewMode.h
//  CheLunShiGuang
//
//  Created by Mike on 15/11/1.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GroupCollectionViewModel : NSObject

@property (nonatomic, assign) BOOL enble;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *name;


/// 返回所有应用信息数据

+(NSArray *)modelData;

@end






