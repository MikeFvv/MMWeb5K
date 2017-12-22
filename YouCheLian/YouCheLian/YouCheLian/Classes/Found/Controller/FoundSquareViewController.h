//
//  FoundSquareViewController.h
//  YouCheLian
//
//  Created by Mike on 16/3/16.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FoundSquareModel,FoundSquareViewController;
@protocol FoundSquareViewControllerDelegate <NSObject>


- (void)foundSquareViewController:(FoundSquareViewController *)foundSquareVC didSelectRowAtIndexPath:(NSIndexPath *)indexPath withModel:(FoundSquareModel *)model;

- (void)FoundSquareViewCell:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imagArray:(NSArray *)imagArray;


@end

@interface FoundSquareViewController : UITableViewController

@property (nonatomic,weak) id<FoundSquareViewControllerDelegate> delegate;
//1我的发现  2发现列表  3我评论过的发现
@property (nonatomic, copy) NSString *squareType;


- (void)getSquareData;

@end
