//
//  CarColorListModel.h
//  motoronline
//
//  Created by Mike on 16/1/25.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
///  颜色列表
@interface CarColorListModel : NSObject

// id
@property (nonatomic, assign) NSInteger colId;
// 颜色名称
@property (nonatomic, copy) NSString *colName;
// 价格
@property (nonatomic, strong) NSNumber *price;
///  库存
@property (nonatomic,strong) NSNumber *stock;


@end
