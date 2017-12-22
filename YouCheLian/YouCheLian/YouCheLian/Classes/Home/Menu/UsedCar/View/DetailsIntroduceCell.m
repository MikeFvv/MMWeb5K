//
//  DetailsIntroduceCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "DetailsIntroduceCell.h"
#import "UsedCarModel.h"
#import <MJExtension.h>
#import "MyModel.h"

@interface DetailsIntroduceCell()

@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation DetailsIntroduceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGRect frame = self.classLabel.frame;
    frame.size.width = kUIScreenWidth / 2;
    self.classLabel.frame = frame;
    _classLabel.textAlignment = NSTextAlignmentLeft;
    _bottomLineView.backgroundColor = kCellBottomView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"DetailsIntroduceCell";
    DetailsIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
    _brandLabel.text = [NSString stringWithFormat:@"品牌: %@",model.brandText];
    _classLabel.text = [NSString stringWithFormat:@"分类: %@",model.typeText];
    _contentLabel.text = [NSString stringWithFormat:@"     %@",model.descrip];
}



///  获取品牌名称
///
///  @param Id 品牌Id
///
///  @return 返回品牌名称
- (NSString *)getBrand:(NSString *)Id {
    // 从文件中加载数组
    NSArray *carArray = [YHFunction arrayWithString:@"carBrand.plist"];
    NSArray *motoArray = [YHFunction arrayWithString:@"motoBrand.plist"];
    // 创建数据用来装模型数据
    NSMutableArray *apps = [NSMutableArray array];
    // 添加第一个plist 文件
    for (NSDictionary *dict in carArray) {
        // 将字典转化模型
        MyModel *model = [MyModel mj_objectWithKeyValues:dict];
        [apps addObject:model];
    }
    // 添加第二个plist 文件
    for (NSDictionary *dict in motoArray) {
        // 将字典转化模型
        MyModel *model = [MyModel mj_objectWithKeyValues:dict];
        [apps addObject:model];
    }
    // 遍历 id
    for (MyModel *model in apps) {
        if ([model.ID isEqualToString:Id]) {
            return model.name;
        }
    }
    return @"";
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
