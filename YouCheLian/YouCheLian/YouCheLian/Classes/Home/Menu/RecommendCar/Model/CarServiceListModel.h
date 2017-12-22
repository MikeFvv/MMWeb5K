//
//  CarServiceListModel.h
//  motoronline
//
//  Created by Mike on 16/1/25.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarServiceListModel : NSObject

// id
@property (nonatomic, strong) NSNumber *serID;
// 服务名称（如：正品保证）
@property (nonatomic, copy) NSString *serName;
// 服务类型 Id可能变化 1=正品保障，2=
@property (nonatomic, strong) NSNumber *type;

@end
