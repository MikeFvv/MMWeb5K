//
//  ReleaseViewModel.h
//  YouCheLian
//
//  Created by Mike on 16/3/8.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ReleaseViewCellTypeImport,
    ReleaseViewCellTypeSelect,
    ReleaseViewCellTypeMutilImport,
} ReleaseViewCellType;


@interface ReleaseViewModel : NSObject
//标题
@property (nonatomic, copy) NSString *title;
//占位内容
@property (nonatomic, copy) NSString *placeholderTitle;
//类型
@property (nonatomic, assign) ReleaseViewCellType cellType;
//cell的高度
@property (nonatomic, assign) CGFloat cellHeight;


+(NSArray *)modelData;

@end
