//
//  GoodsServiceCell.m
//  motoronline
//
//  Created by Mike on 16/1/26.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import "GoodsServiceCell.h"
#import "CarServiceListModel.h"

@implementation GoodsServiceCell

-(void)setDataModels:(NSArray *)dataModels{
    _dataModels = dataModels;
    
    //列数
    int totalCol = 3;
    //行数
//    int totalRow = (int)(self.dataModels.count / totalCol) + 1;
    //    int totalRow = 10 / totalCol;
    //间距
//    CGFloat margin = 8.0;
    //按钮的宽
    CGFloat btnWidth = kUIScreenWidth  / totalCol;
    //按钮的高
    CGFloat btnHeight = 30;
    //中间的服务
    for (int i = 0; i < self.dataModels.count; i++) {
        
        int rowNum = i / totalCol;
        int colNum = i % totalCol;
        //取出模型
        NSString *iconName = nil;
        CarServiceListModel *model = self.dataModels[i];
        //根据类型判断显示什么图片
        int type = model.serID.intValue;   // ^^^
        //Id可能变化 1=正品保障，2=售后保障, 3=极速退款，4=七天无理由
        if(type == 1){
            iconName = @"service_zheng.png";
        }else if (type == 2){
            iconName = @"service_bao.png";
        }else if (type == 3){
            iconName = @"service_jisu.png";
        }else if (type == 4){
            iconName = @"service_qi.png";
        }
        
        //服务按钮
        UIButton *servicBtn = [[UIButton alloc] init];
        servicBtn.enabled = NO;
//        servicBtn.layer.cornerRadius = 3;
//        servicBtn.layer.borderWidth = 1;
//        servicBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        servicBtn.tag = 100 + i;
        
        if (colNum == 0) {
            servicBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            // 让返回按钮内容继续向右边偏移10
                servicBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        }else if (colNum == 1){
            servicBtn.contentMode = UIViewContentModeTop;
        }else{
            servicBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            // 让返回按钮内容继续向右边偏移10
            servicBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        
        }

        [servicBtn setTitle:model.serName forState:UIControlStateNormal];
        [servicBtn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
        [servicBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [servicBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.contentView addSubview:servicBtn];
        
        //服务按钮约束
        [servicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(self.contentView.mas_top).offset(self.dataModels.count < 4 ? (40 - 30) / 2.0 : btnHeight * rowNum);
            make.left.mas_equalTo(self.contentView.mas_left).offset( btnWidth * colNum);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(btnHeight);
            
        }];
        
    }
    

}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"GoodsServiceCell";
    GoodsServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        //
        cell = [[GoodsServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    // cell 被选中时的风格  灰色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
