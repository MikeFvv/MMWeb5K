//
//  ReleaseCollectionViewCell.h
//  YouCheLian
//
//  Created by Mike on 16/3/8.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReleaseCollectionViewCell;

@protocol ReleaseCollectionViewCellDeleagate <NSObject>

- (void)releaseCollectionViewCellDidClickDeleteBtn:(ReleaseCollectionViewCell *)cell;

@end


@interface ReleaseCollectionViewCell : UICollectionViewCell


@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) BOOL deleteBtnHidden;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (nonatomic, weak) id<ReleaseCollectionViewCellDeleagate> delegate;



@end
