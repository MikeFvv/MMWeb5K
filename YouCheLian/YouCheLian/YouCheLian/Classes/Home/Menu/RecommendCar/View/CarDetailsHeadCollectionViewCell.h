//
//  CarDetailsHeadCollectionViewCell.h
//  motoronline
//
//  Created by Mike on 16/2/18.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarDetailsHeadCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imagStr;
@property (weak, nonatomic) IBOutlet UIImageView *imagView;

@end
