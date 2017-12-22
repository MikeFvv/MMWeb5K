//
//  HMSettingCell.m
//  网易彩票
//
//  Created by Apple on 15/7/12.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "SettingCell.h"
#import "SettingItem.h"
#import "SettingItemArrow.h"
#import "SettingItemSwitch.h"
@interface SettingCell()
/**
 *  箭头
 */
@property(nonatomic,strong) UIImageView *arrowView;

/**
 *  开关
 */
@property(nonatomic,strong) UISwitch *st;

/**
 *  分割线
 */
@property(nonatomic,strong) UIView *lineView;
/**
 * 文本标签
 */
@property(nonatomic,strong) UILabel *labelView;
@end

@implementation SettingCell
#pragma mark - 初始化方法
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"setting";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
/**
 *  添加子控件
 */
- (void)setup{
    // 添加分割线
    [self.contentView addSubview:self.lineView];
    // 设置cell的背景颜色
    [self setupCellBgColor];
}

/**
 *  设置cell的背景颜色
 */
- (void)setupCellBgColor{
    // 设置cell背景色
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = backgroundView;
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [UIColor grayColor];
    self.selectedBackgroundView = selectedBackgroundView;
    
    // 设置文本标签的字体和颜色
    self.textLabel.font = YHFont(14, NO);;
    self.textLabel.textColor = kFontColor;
    
    self.detailTextLabel.font = YHFont(12, NO);;
    self.detailTextLabel.textColor = [UIColor brownColor];
}

#pragma mark - 懒加载控件
/**
 *  箭头
 */
- (UIImageView *)arrowView {
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    }
    return _arrowView;
}
/**
 *  开关
 */
- (UISwitch *)st{
    if (!_st) {
        _st = [[UISwitch alloc] init];
        // 监听开关值的改变
        [_st addTarget:self action:@selector(stValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _st;
}

/**
 *  分割线
 */
- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.alpha = 0.3;
    }
    return _lineView;
}


#pragma mark - 监听开关值的改变
- (void)stValueChanged {
    SettingItemSwitch *itemSt = (SettingItemSwitch *)_item;
    itemSt.on = _st.on;
}

#pragma mark - 设置数据
- (void)setItem:(SettingItem *)item {
    _item = item;
    // 设置子控件内容
    [self  setupData];
    // 设置右边显示的控件
    [self setupRightAccessoryView];
}
/**
 *  设置子控件内容
 */
- (void)setupData{
    if (_item.icon) {
        self.imageView.image = [UIImage imageNamed:_item.icon];
    }
    self.textLabel.text = _item.title;
    self.detailTextLabel.text = _item.subTitle;
}
/**
 *  设置右边显示的控件
 */
- (void)setupRightAccessoryView{
    // 设置cell是否可以显示选中效果
    self.selectionStyle =([_item isKindOfClass:[SettingItemSwitch class]]) ? UITableViewCellSelectionStyleNone:UITableViewCellSelectionStyleDefault;
    
    if ([_item isKindOfClass:[SettingItemArrow class]]) { // 箭头
        self.accessoryView = self.arrowView;
    } else if([_item isKindOfClass:[SettingItemSwitch class]]) { // 开关
        // 获得开关状态值
        SettingItemSwitch *itemSt = (SettingItemSwitch *) _item;
        self.st.on = itemSt.on;
        
        self.accessoryView = self.st;
    } else  {
        self.accessoryView = nil;
    }
}
/**
 *  设置分割线隐藏状态
 */
//- (void)setHideLine:(BOOL)hideLine {
//    _hideLine = hideLine;
//    self.lineView.hidden = hideLine;
//}

#pragma mark - 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat lineH = 1;
    CGFloat lineX = CGRectGetMinX(self.textLabel.frame);
    CGFloat lineW = CGRectGetWidth(self.frame);
    CGFloat lineY = CGRectGetHeight(self.frame) - lineH;
    self.lineView.frame = CGRectMake(lineX -15, lineY, lineW, lineH);
}

@end
