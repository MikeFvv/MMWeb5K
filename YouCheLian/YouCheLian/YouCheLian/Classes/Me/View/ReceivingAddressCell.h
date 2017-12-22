//
//  ReceivingAddressCell.h
//  YouCheLian
//
//  Created by Mike on 15/11/24.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceivingAddressModel.h"

@interface ReceivingAddressCell : UITableViewCell

@property (nonatomic, copy)NSString *nameStr;
@property (nonatomic, copy)NSString *addressStr;
@property (nonatomic, copy)NSString *postcodeStr;

@property (nonatomic, strong) ReceivingAddressModel *model;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
