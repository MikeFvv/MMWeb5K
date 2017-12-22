//
//  ReceivingAddressCell.m
//  YouCheLian
//
//  Created by Mike on 15/11/24.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "ReceivingAddressCell.h"
#import "CityOneModel.h"
#import "CityTwoModel.h"
#import "CityThreeModel.h"

@interface ReceivingAddressCell()

// 收货人姓名
@property (weak, nonatomic) IBOutlet UILabel *name;
// 收货地址
@property (weak, nonatomic) IBOutlet UILabel *address;
// 邮政编码
@property (weak, nonatomic) IBOutlet UILabel *postcode;
// 联系电话
@property (weak, nonatomic) IBOutlet UILabel *phone_number;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;


@property (nonatomic, strong) NSArray *cityArray;

@end

@implementation ReceivingAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ReceivingAddressCell";
    ReceivingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    cell.backgroundColor = [UIColor whiteColor];
    // cell 被选中时的风格  
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)initData {
    NSMutableArray *cityData = [CityOneModel mj_objectArrayWithFilename:@"citydata.plist"];
    _cityArray = cityData;
}


- (void)setModel:(ReceivingAddressModel *)model {
    _model = model;
    
    NSString *cityName;
    if (![model.areaid isEqualToString:@""]) {
        cityName = [self getCity:model.areaid];
    } else if (![model.cityid isEqualToString:@""]) {
        cityName = [self getCity:model.cityid];
    } else if (![model.cityid isEqualToString:@""]) {
        cityName = [self getCity:model.provinceid];
    } else {
        
    }
    _name.text = model.name;
    _address.text = [NSString stringWithFormat:@"%@%@", cityName, model.address];
    _postcode.text = model.zipcode;
    _phone_number.text = model.linkPhone;
    
    if (model.isDefault.integerValue == 1) {
        _defaultLabel.text = @"默认地址";
    } else {
        _defaultLabel.text = @"";
    }
}


/// 获取省市名
///
///  @param areaId 省市id
///  @return   可以返回3级省市名称
- (NSString *)getCity:(NSString *)areaId {
    // 从文件中加载数组
    NSArray *appArray = [YHFunction arrayWithString:@"citydata.plist"];
    // 创建数据用来装模型数据
    NSMutableArray *apps = [NSMutableArray array];
    for (NSDictionary *dict in appArray) {
        // 将字典转化模型
        CityOneModel *model = [CityOneModel mj_objectWithKeyValues:dict];
        [apps addObject:model];
    }
    
    // 一级一级遍历下去， 遍历到了把上一级拼接一起返回
    for (CityOneModel *oneModel in apps) {
        if ([oneModel.pId isEqualToString:areaId]) {
            return oneModel.provinceName;
        }
        for (CityTwoModel *twoModel in oneModel.citylist) {
            if ([twoModel.cId isEqualToString:areaId]) {
                return [NSString stringWithFormat:@"%@%@",oneModel.provinceName,twoModel.cityName];
            }
            for (CityThreeModel *threeModel in twoModel.arealist) {
                if ([threeModel.aId isEqualToString:areaId]) {
                    return [NSString stringWithFormat:@"%@%@%@",oneModel.provinceName, twoModel.cityName, threeModel.areaName];
                }
            }
        }
    }
    return @"";
}


#pragma mark - 设置默认地址
/// 设置默认地址
- (IBAction)setDefaultAddressAction:(id)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


@end
