//
//  MeModel.h
//  YouCheLian
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MeModel;
@interface MeCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView meModel:(MeModel*)mineModel;

@end
