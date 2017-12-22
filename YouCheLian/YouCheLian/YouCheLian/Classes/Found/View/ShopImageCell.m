//
//  ShopImageCell.m
//  YouCheLian
//
//  Created by Mike on 15/12/11.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "ShopImageCell.h"
#import "ShopDetailsModel.h"
#import "UIImageView+WebCache.h"

#define kViewHeight 45

@interface ShopImageCell()

// 营业时间
@property (strong, nonatomic)  UILabel *timeTitleLabel;
@property (strong, nonatomic)  UILabel *timeLabel;
// 收藏 心型图标
@property (strong, nonatomic)  UIButton *collectionImgBtn;
// 收藏
@property (strong, nonatomic)  UILabel *collectionLabel;

@property (strong, nonatomic)  UIView *storeView;


@property (strong, nonatomic)  UILabel *pageLabel;

@property (strong, nonatomic)  UIView *line1;

//@property (strong, nonatomic)  UILabel *textLabel1;
//@property (strong, nonatomic)  UILabel *textLabel2;



@end

@implementation ShopImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



+(instancetype)cellWithTableView:(UITableView *)tableView {
    //  这个 静态字符串不要与类名相同
    static NSString *ID = @"ShopImageCell";
    ShopImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ShopImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imgUrlView = [[UIImageView alloc] init];
        // 图片做等比例放大、超出部分裁剪、居中处理
        _imgUrlView.contentMode = UIViewContentModeScaleAspectFill;
        _imgUrlView.clipsToBounds = YES;  // 超出边框的内容都剪掉
        
        _imgUrlView.userInteractionEnabled = YES;
        _imgUrlView.image = [UIImage imageNamed:@"image_placeholder"];
        
        //添加图片的点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageView)];
        //添加手势到视图
        [_imgUrlView addGestureRecognizer:tap];
        
        [self addSubview:_imgUrlView];
        
        [_imgUrlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.size.mas_equalTo(CGSizeMake(kUIScreenWidth, kHeadImagHeight));
        }];
        
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = YHFont(14, NO);;
        _timeLabel.textColor = [UIColor whiteColor];
        [_imgUrlView addSubview:_timeLabel];
        
        UILabel *timeTitleLabel = [[UILabel alloc] init];
        timeTitleLabel.text = @"营业时间";
        timeTitleLabel.font = YHFont(14, NO);;
        timeTitleLabel.textColor = [UIColor whiteColor];
        [_imgUrlView addSubview:timeTitleLabel];
        
        //        UILabel *collectionLabel = [[UILabel alloc] init];
        //        collectionLabel.text = @"收藏";
        //        collectionLabel.font = YHFont(14, NO);;
        //        collectionLabel.textColor = [UIColor whiteColor];
        //        [_imgUrlView addSubview:collectionLabel];
        
        _collectionImgBtn = [[UIButton alloc] init];
        [_collectionImgBtn setTitle:@"收藏" forState:UIControlStateNormal];
        _collectionImgBtn.titleLabel.font = YHFont(14, NO);
        [_collectionImgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _collectionImgBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_collectionImgBtn addTarget:self action:@selector(collectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_imgUrlView addSubview:_collectionImgBtn];
        
        UILabel *pageLabel = [[UILabel alloc] init];
        pageLabel.text = [NSString stringWithFormat:@"- / -"];
        pageLabel.font = YHFont(14, NO);
        pageLabel.textColor = [UIColor whiteColor];
        [_imgUrlView addSubview:pageLabel];
        _pageLabel = pageLabel;
        
        UIView *line1 = [[UIView alloc] init];
        line1.backgroundColor = [UIColor whiteColor];
        [self addSubview:line1];
        _line1 = line1;
        
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgUrlView.mas_left).with.offset(15);
            make.bottom.mas_equalTo(_imgUrlView.mas_bottom).with.offset(-10);
        }];
        
        [timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgUrlView.mas_left).with.offset(15);
            make.bottom.mas_equalTo(_timeLabel.mas_top).with.offset(-5);
        }];
        
        [_collectionImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_imgUrlView.mas_right).with.offset(-15);
            make.bottom.mas_equalTo(_imgUrlView.mas_bottom).with.offset(-8);
            make.size.mas_equalTo(CGSizeMake(70, 30));
        }];
        
        [_pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_collectionImgBtn.mas_left).with.offset(-10);
            make.centerY.mas_equalTo(_collectionImgBtn.mas_centerY);
        }];
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_collectionImgBtn.mas_left);
            make.centerY.mas_equalTo(_collectionImgBtn.mas_centerY);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(_pageLabel.mas_height);
        }];
        
        
        
        _storeView = [[UIView alloc] init];
        _storeView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_storeView];
        
        // 竖线 rectangal
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.image = [UIImage imageNamed:@"rectangal"];
        [_storeView addSubview:iconView];
        
        UILabel *discountLabel = [[UILabel alloc] init];
        discountLabel.text = @"店铺优惠活动";
        discountLabel.font = YHFont(14, NO);
        discountLabel.textColor = kGlobalFontColor;
        [_storeView addSubview:discountLabel];
        
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = kLineBackColor;
        [self addSubview:lineView1];
        
        /*****店铺优惠活动*****/
        //创建一个点击手势对象，该对象可以调用handelTap：方法
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTap:)];
        [_storeView addGestureRecognizer:tapGes];
        [tapGes setNumberOfTouchesRequired:1];  //触摸点个数
        [tapGes setNumberOfTapsRequired:1]; //点击次数
        
        [_storeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imgUrlView.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(kViewHeight);
        }];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_storeView.mas_centerY);
            make.left.mas_equalTo(_storeView.mas_left).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(5, 22));
        }];
        
        [discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_storeView.mas_centerY);
            make.left.mas_equalTo(iconView.mas_right).with.offset(10);
        }];
        
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_storeView.mas_bottom);
            make.left.mas_equalTo(_storeView.mas_left);
            make.right.mas_equalTo(_storeView.mas_right);
            make.height.mas_equalTo(1);
        }];
        
    }
    return self;
}


- (void)setModel:(ShopDetailsModel *)model {
    _model = model;
    
    [_imgUrlView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    
    _timeLabel.text = model.BusinessHours;
    
    
    if (![UserDefaultsTools boolForKey:ShopColStr]) { // 未收藏
        [_collectionImgBtn setImage:[UIImage imageNamed:@"collectionHeart_normal"] forState:UIControlStateNormal ];
    } else {  // 已收藏
        [_collectionImgBtn setImage:[UIImage imageNamed:@"collectionHeart_press"] forState:UIControlStateNormal ];
    }
}

- (void)setIconCount:(int)iconCount {
    _iconCount = iconCount;
    
    if (iconCount != 0 ) {
        
        _pageLabel.text = [NSString stringWithFormat:@"1 / %d",self.iconCount];
        _line1.hidden = NO;
    }else{
        
        _pageLabel.text = @"";
        _line1.hidden = YES;
    }
    
}



#pragma mark - 点击图片放大浏
//点击图片放大浏览
-(void)clickImageView
{
    if ([self.delegate respondsToSelector:@selector(clickImageView)]) {
        [self.delegate clickImageView];
    }
}

#pragma mark - 收藏
// 收藏
- (void)collectBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(collectBtnAction:)]) {
        [self.delegate collectBtnAction:sender];
    }
}


#pragma mark - 点击View  店铺优惠活动
// 点击View  店铺优惠活动
- (void)handelTap:(UITapGestureRecognizer *)tgp {
    
    if ([self.delegate respondsToSelector:@selector(didViewSelectItemAtIndexPath)]) {
        [self.delegate didViewSelectItemAtIndexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
