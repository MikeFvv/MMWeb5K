//
//  MyModel.h
//  TableViewIndex
//
//  Created by Mike on 15/12/8.
//  Copyright © 2015年 微微. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyModel : NSObject
/*
 用户名
 */
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *ID;

//@property (nonatomic, copy) NSString *UserName;


/**
 *  快速创建一个模型对象
 *
 */
+(instancetype)appWithDict:(NSDictionary *)dict;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
