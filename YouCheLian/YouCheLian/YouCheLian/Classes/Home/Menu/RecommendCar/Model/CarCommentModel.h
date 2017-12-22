//
//  CarCommentModel.h
//  motoronline
//
//  Created by Mike on 16/1/27.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 评价
@interface CarCommentModel : NSObject

// 评价用户昵称
@property (nonatomic, copy) NSString *nickName;
// 用户头像地址
@property (nonatomic, copy) NSString *headUrl;
// 评价内容
@property (nonatomic, copy) NSString *content;
// 评价时间
@property (nonatomic, copy) NSString *addTime;
// 订单备注
@property (nonatomic, copy) NSString *oderRemark;
// 发表图片地址url多了用”,”分割,如果没有图片=0
@property (nonatomic, copy) NSString *imageUrls;
// 评价等级 1.好评 2.中评 3.差评
@property (nonatomic,strong) NSNumber *grade;

@property (nonatomic, assign) CGFloat cellHeight;

@end
