//
//  InformationViewController.h
//  YouCheLian
//
//  Created by Mike on 15/11/26.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopCollcctionControllerDelegate <NSObject>

- (void)jumpShopDetailsDelegate:(NSString *)shopId;

@end


/// 收藏的店铺
@interface ShopCollcctionController : UITableViewController

//@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) id<ShopCollcctionControllerDelegate> delegate;

@end
