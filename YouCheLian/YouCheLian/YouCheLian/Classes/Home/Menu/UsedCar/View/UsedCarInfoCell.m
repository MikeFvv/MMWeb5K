//
//  UsedCarInfoCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UsedCarInfoCell.h"
#import "UsedCarModel.h"
#import "CityOneModel.h"
#import "CityTwoModel.h"
#import "CityThreeModel.h"

@interface UsedCarInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactsLabel;
@property (weak, nonatomic) IBOutlet UILabel *iphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;
@property (weak, nonatomic) IBOutlet UILabel *excellentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *excellentImagView;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation UsedCarInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bottomLineView.backgroundColor = kCellBottomView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UsedCarInfoCell";
    UsedCarInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setModel:(UsedCarModel *)model {
    _model = model;
    
    _titleLabel.text = model.title;
    _contactsLabel.text = [NSString stringWithFormat:@"联系人:%@",model.contactName];
    _iphoneLabel.text = [NSString stringWithFormat:@"联系电话:%@",model.contact_Phone];
    
    NSString *areaName = [self getCity:model.areaid];
    _mapLabel.text = [NSString stringWithFormat:@"区域:%@",areaName]; // 区域id 需查询对应的name显示
    if (model.ifTop.integerValue == 1) {   // 1 认证
        _excellentImagView.image = [UIImage imageNamed:@"excellent"];
        _excellentLabel.text = @"优车联认证，100%真实信息";
    } else {  // 0 未认证
        _excellentImagView.image = [UIImage imageNamed:@""];
        _excellentLabel.text = @"";
    }
    if (model.price.floatValue <= 0) {
        _priceLabel.text = @"面议";
        _unitLabel.text = @"";
    } else {
        _priceLabel.text = model.price;
        _unitLabel.text = @"元";
    }
    
}

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
