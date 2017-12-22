//
//  FoundCommentModel.h
//  YouCheLian
//
//  Created by Mike on 16/3/21.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoundCommentModel : NSObject

/// 评论ID
@property (nonatomic, strong) NSNumber *cmID;
/// 用户头像
@property (nonatomic, copy) NSString *imgUrl;
/// 用户昵称
@property (nonatomic, copy) NSString *Nick;
/// 评论内容
@property (nonatomic, copy) NSString *comment;
/// 评价时间
@property (nonatomic, copy) NSString *addTime;
/// 1代表是我发布的， 0不是
@property (nonatomic, assign) BOOL isMyComment;

/// 行高
@property (nonatomic, assign) CGFloat cellHeight;


@end
