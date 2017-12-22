//
//  CarDetailsSubViewController.h
//  motoronline
//
//  Created by Mike on 16/1/29.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import "BaseViewController.h"
#import "FlipTableView.h"
#import "SegmentTapView.h"
#import "SpecificationsViewController.h"

@protocol CarDetailsSubViewControllerDelegate <NSObject>

-(void)carDetailsSubDownRefresh;

- (void)carEvaluationCellCell:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imagArray:(NSArray *)imagArray;
@end

@interface CarDetailsSubViewController : BaseViewController
//规格参数
@property (nonatomic, copy) NSString *spec;
//图文详情
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *carId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) SegmentTapView *segment;
@property (nonatomic, strong) FlipTableView *flipView;

@property (nonatomic,weak) id<CarDetailsSubViewControllerDelegate> delegate;

@end
