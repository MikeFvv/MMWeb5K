//
//  MeHeaderView.h
//  YouCheLian
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonalInfoModel;

@protocol MeHeaderViewDelegate <NSObject>

@optional

///消息
- (void)newsBtnAction;
/// 登录 个人信息 编辑
- (void)loginOrEditDelegateAction;

@end

@interface MeHeaderView : UIView

@property (strong, nonatomic) UIImageView *bgImagView;

@property (nonatomic, strong) PersonalInfoModel *model;

// 未查看系统消息条数
@property (nonatomic, strong) NSNumber *sysmsgneedreadNum;

@property (nonatomic, weak) id <MeHeaderViewDelegate> delegate;
- (void)scrollDidScroll:(UIScrollView *)scrollView;


@end




