//
//  GoodsCollectionController.h
//  YouCheLian
//
//  Created by Mike on 16/3/24.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsCollectionControllerDelegate <NSObject>

- (void)jumpGoodsDetailsDelegate:(NSString *)goodsId;

@end

/// 收藏的商品
@interface GoodsCollectionController : UICollectionViewController

@property (nonatomic, weak) id<GoodsCollectionControllerDelegate> delegate;

@end
