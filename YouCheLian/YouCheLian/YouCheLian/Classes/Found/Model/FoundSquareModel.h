//
//  FoundSquareModel.h
//  YouCheLian
//
//  Created by Mike on 16/3/17.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoundSquareModel : NSObject
/// 发现id
@property (nonatomic, strong) NSNumber *ID;
/// 用户头像
@property (nonatomic, copy) NSString *userImg;
/// 用户昵称
@property (nonatomic, copy) NSString *userNickname;
/// 发现内容
@property (nonatomic, copy) NSString *content;
/// 点赞数
@property (nonatomic, assign) int upvoteNum;
/// 0未点赞 1已点赞
@property (nonatomic, assign) BOOL isUpvote;
/// 评论数
@property (nonatomic, assign) int commentNum;
/// 发表时间
@property (nonatomic, copy) NSString *publishTime;
//0待审核1审核通过2审核不通过
@property (nonatomic, copy) NSString *ndStatus;
/// 图片列表
@property (nonatomic, strong) NSArray *lstImage;


@property (nonatomic, assign) CGFloat cellHeight;


@end

@interface FoundSquareImageModel : NSObject

/// 图片id
@property (nonatomic, strong) NSNumber *ID;

/// 图片url
@property (nonatomic, copy) NSString *imageData;

@end
