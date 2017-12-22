//
//  MeSystemMessageModel.h
//  YouCheLian
//
//  Created by Mike on 16/3/23.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeSystemMessageModel : NSObject

// 系统消息ID
@property (nonatomic, copy) NSString *ID;
// 系统消息标题
@property (nonatomic, copy) NSString *title;
// 发布时间
@property (nonatomic, copy) NSString *addTime;
// 系统消息内容
@property (nonatomic, copy) NSString *content;
// 1已读 0未读
@property (nonatomic, copy) NSString *isRead;

@end
