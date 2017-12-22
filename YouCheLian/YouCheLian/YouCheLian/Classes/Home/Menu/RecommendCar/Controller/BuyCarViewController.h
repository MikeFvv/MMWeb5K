//
//  BuyCarViewController.h
//  motoronline
//
//  Created by Mike on 16/1/26.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class BuyCarViewController;

@protocol BuyCarViewControllerDelegate <NSObject>

- (void)buyCarViewController:(BuyCarViewController *)vc exitWithSelectIndex:(NSInteger) selectIndex andBuyCount:(int) buyCount;



@end

@interface BuyCarViewController : BaseViewController

///  商品id
@property (nonatomic, copy) NSString *carId;
///   0=商城,1=新车，2=活动车
@property (nonatomic, copy) NSString *type;
//数据模型数组
@property (nonatomic, strong) NSArray *dataModels;
/// 价格
@property (nonatomic, copy) NSString *price;
/// 市场价
@property (nonatomic, copy) NSString *marketPrice;
/// 定金 定金=0此商品支付活动价，定金>0商品支付为定金
@property (nonatomic, copy) NSString *earnestMoney;

@property (nonatomic, assign) NSInteger selectIndex ;
//购买数量
@property (nonatomic, assign) int buyCount;

@property (nonatomic, copy) NSString *motoPhoto;

@property (nonatomic, weak) id<BuyCarViewControllerDelegate> delegate;

- (void)show;
//取消按钮
- (void)cancleBtnClick;

@end
