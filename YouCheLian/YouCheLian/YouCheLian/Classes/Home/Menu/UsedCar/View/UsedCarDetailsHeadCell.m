//
//  UsedCarDetailsHeadCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UsedCarDetailsHeadCell.h"
#import "UsedCarModel.h"

@interface UsedCarDetailsHeadCell()


@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation UsedCarDetailsHeadCell


- (void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    //  这个 静态字符串不要与类名相同
    static NSString *ID = @"UsedCarDetailsHeadCell";
    UsedCarDetailsHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UsedCarDetailsHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//        cell.selectedBackgroundView.backgroundColor = RGB(239, 239, 239);
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
//withFrame:(CGRect)frame
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight * kHeadCellHeight)];
        _imagView.backgroundColor = [UIColor clearColor];
        // 图片做等比例放大、超出部分裁剪、居中处理
        _imagView.contentMode = UIViewContentModeScaleAspectFill;
        _imagView.clipsToBounds = YES;  // 超出边框的内容都剪掉
        _imagView.userInteractionEnabled = YES;
        //添加图片的点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didImageAction:)];
        //添加手势到视图
        [_imagView addGestureRecognizer:tap];
        
        [self addSubview:_imagView];
        UIImageView *numImagView = [[UIImageView alloc] init];
        numImagView.image = [UIImage imageNamed:@"icon_imageNum"];
        [_imagView addSubview:numImagView];
        
        _numLabel = [[UILabel alloc] init];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.font = YHFont(10, NO);;
        [numImagView addSubview:_numLabel];
        
        [numImagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_imagView.mas_bottom).with.offset(0);
            make.right.equalTo(_imagView.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(63, 24));
        }];
        
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(numImagView.mas_centerX);
            make.centerY.mas_equalTo(numImagView.mas_centerY);
        }];
        
    }
    return self;
}


- (void)setModel:(UsedCarModel *)model {
    _model = model;
    NSArray *urlArray = [model.imageUrl componentsSeparatedByString:@","];

//    [self.imagView ww_setImageWithString:urlArray[0] wihtImgName:@"image_placeholder"];
    
    if (urlArray.count > 0) {
        _numLabel.text = [NSString stringWithFormat:@"1/%zd",urlArray.count-1];
    } else {
        self.imagView.image = [UIImage imageNamed:@"image_placeholder"];
        _numLabel.text = [NSString stringWithFormat:@"0/0"];
    }
    
}

// 个人信息
- (void)didImageAction:(UITapGestureRecognizer *)tap {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didHeaderImageAction)]) {
        [self.delegate didHeaderImageAction];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
