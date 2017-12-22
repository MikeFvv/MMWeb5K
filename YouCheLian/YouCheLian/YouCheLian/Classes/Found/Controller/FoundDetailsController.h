//
//  FoundDetailsController.h
//  YouCheLian
//
//  Created by Mike on 16/3/19.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "BaseViewController.h"

@interface FoundDetailsController : BaseViewController

//发现id
@property (nonatomic,assign) NSInteger ID;
/// 0未点赞 1已点赞
@property (nonatomic, assign) BOOL isUpvote;

//@property (nonatomic, assign) BOOL showDeleteBtn;

@end
