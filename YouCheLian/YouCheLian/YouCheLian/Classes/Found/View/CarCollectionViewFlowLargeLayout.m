//
//  CarCollectionViewFlowLargeLayout.m
//  YouCheLian
//
//  Created by Mike on 16/3/22.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "CarCollectionViewFlowLargeLayout.h"

@implementation CarCollectionViewFlowLargeLayout

-(id)init
{
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(kUIScreenWidth/2-3, 240);
    self.sectionInset = UIEdgeInsetsMake(12, 0, 0, 0);
    self.minimumInteritemSpacing = 6.0f;
    self.minimumLineSpacing = 6.0f;
    
    return self;
}

@end
