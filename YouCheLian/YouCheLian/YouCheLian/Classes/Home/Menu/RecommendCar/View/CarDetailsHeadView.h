//
//  CarDetailsHeadView.h
//  motoronline
//
//  Created by Mike on 16/2/18.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CarDetailsHeadViewDelegate <NSObject>

- (void)carDetailsHeadViewCell:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end




@interface CarDetailsHeadView : UIView

// headView的模型，重写set方法
@property(nonatomic,strong) NSArray *imagArray;

@property (nonatomic, strong)NSArray *arrayImageUrl;
@property (nonatomic, weak) id<CarDetailsHeadViewDelegate> delegate;

@end
