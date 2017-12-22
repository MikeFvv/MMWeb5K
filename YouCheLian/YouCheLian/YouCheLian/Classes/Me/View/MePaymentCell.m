//
//  MePaymentCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/24.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "MePaymentCell.h"
#import "OrderInfoModel.h"

@interface MePaymentCell()
// 待支付
@property (nonatomic, strong) UILabel *paymentLabel;
// 待收货
@property (nonatomic, strong) UILabel *goodsLabel;
// 待评价
@property (nonatomic, strong) UILabel *evaluateLabel;

@end

@implementation MePaymentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)cellWithTableView:(UITableView *)tableView {
    //  这个 静态字符串不要与类名相同
    static NSString *ID = @"MePaymentCell";
    MePaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MePaymentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 1)];
        //        lineView.backgroundColor = kLineBackColor;
        //        [self addSubview:lineView];
        
        NSArray *imgArray = @[@"me_daifukuan",@"me_daishouhuo",@"me_daipingjia",@"me_service"];
        NSArray *arrayTitle = @[@"待支付", @"待收货",@"已结束",@"售后"];
        
        NSInteger numCount = 3;
        for (NSInteger i = 0; i < numCount; i++) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * kUIScreenWidth/numCount, 0, kUIScreenWidth/numCount, 70)];
            //添加图片的点击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickViewTag:)];
            //添加手势到视图
            [view addGestureRecognizer:tap];
            view.tag = 2000+i;
            [self addSubview:view];
            
            UIImageView *image = [[UIImageView alloc] init];
            image.image = [UIImage imageNamed:imgArray[i]];
            [view addSubview:image];
            
            UILabel *label = [[UILabel alloc] init];
            label.text = arrayTitle[i];
            label.font = YHFont(14, NO);;
            label.textColor = kFontColorGray;
            [view addSubview:label];
            
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(view.mas_centerX);
                make.top.mas_equalTo(view.mas_top).with.offset(7);
                make.size.mas_equalTo(CGSizeMake(32, 35));
            }];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(view.mas_centerX);
                make.top.mas_equalTo(image.mas_bottom).with.offset(4);
            }];
            
            UILabel *iconLabel = [[UILabel alloc] init];
            iconLabel.layer.cornerRadius = 14/2;
            iconLabel.textAlignment = NSTextAlignmentCenter;
            //            iconLabel.layer.borderWidth = 1;
            //            iconLabel.layer.borderColor = [UIColor redColor].CGColor;
            iconLabel.clipsToBounds = YES;  // 超出边框的内容都剪掉
            iconLabel.textColor = [UIColor whiteColor];
//            iconLabel.text = @"99";
            iconLabel.font = YHFont(12, NO);
            iconLabel.backgroundColor = [UIColor redColor];
            
            if (i  == 0) {
                _paymentLabel = iconLabel;
            } else if (i  == 1) {
                _goodsLabel = iconLabel;
            }else if (i  == 2) {
                _evaluateLabel = iconLabel;
            }
            
            [view addSubview:iconLabel];
            
            [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(image.mas_right);
                make.centerY.mas_equalTo(image.mas_top).with.offset(5);
            }];
            
        }
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = kViewControllerColor;
        [self addSubview:bottomView];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(13);
        }];
        
    }
    return self;
}



- (void)setModel:(OrderInfoModel *)model {
    
    // 待支付
    _paymentLabel.text = model.paymentNum.stringValue;
    // 待收货
    _goodsLabel.text = model.confirmNum.stringValue;
    // 待评价
    _evaluateLabel.text = model.evaluationNum.stringValue;
    
    // ******* 判断字符个数 ， 给指定宽度 及 裁剪半径 *******
    // 待支付
    if (model.paymentNum.stringValue.length == 1) {
        [_paymentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(14);
        }];
        
        if (model.paymentNum.integerValue == 0) {
            _paymentLabel.text = @"";
        }
        
    } else if (model.paymentNum.stringValue.length == 2) {
        [_paymentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(22);
        }];
    }else if (model.paymentNum.stringValue.length > 2) {
        [_paymentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
        }];
        _paymentLabel.text = @"99+";
    }
    
    
    
    // 待收货
    if (model.confirmNum.stringValue.length == 1) {
        [_goodsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(14);
        }];
        if (model.confirmNum.integerValue == 0) {
            _goodsLabel.text = @"";
        }
        
    } else if (model.confirmNum.stringValue.length == 2) {
        [_goodsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(22);
        }];
    }else if (model.confirmNum.stringValue.length > 2) {
        [_goodsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
        }];
        _goodsLabel.text = @"99+";
    }
    
    
    
    // 待评价
    if (model.evaluationNum.stringValue.length == 1) {
        [_evaluateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(14);
        }];
        if (model.evaluationNum.integerValue == 0) {
            _evaluateLabel.text = @"";
        }
        
    } else if (model.evaluationNum.stringValue.length == 2) {
        [_evaluateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(22);
        }];
        
    }else if (model.evaluationNum.stringValue.length > 2) {
        [_evaluateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
        }];
        _evaluateLabel.text = @"99+";
    } 
    
}




- (void)onClickViewTag:(UITapGestureRecognizer *)tgp {
    
    if ([self.delegate respondsToSelector:@selector(onClickViewTagDelegate:)]) {
        [self.delegate onClickViewTagDelegate:tgp.view.tag - 2000];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
