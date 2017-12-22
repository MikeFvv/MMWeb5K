//
//  UsedCarCommentModel.h
//  YouCheLian
//
//  Created by Mike on 16/3/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsedCarCommentModel : NSObject

///  id
@property (nonatomic, strong) NSNumber *messageid;
///  评论用户
@property (nonatomic, copy) NSString *userPhone;
///  昵称
@property (nonatomic, copy) NSString *nickName;
///  头像
@property (nonatomic, copy) NSString *headUrl;
///  评论内容
@property (nonatomic, copy) NSString *content;
///  1=男，2=女
@property (nonatomic, strong) NSNumber *sex;
///  时间
@property (nonatomic, copy) NSString *addTime;

@property (nonatomic, assign) CGFloat cellHeight;

@end

