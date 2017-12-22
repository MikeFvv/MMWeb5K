//
//  AdsTableCell.m
//  YouCheLian
//
//  Created by Mike on 15/12/5.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "AdsTableCell.h"
#import "SDCycleScrollView.h"


@interface AdsTableCell()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *adsView;
@property (nonatomic, strong) SDCycleScrollView *sDCycleScrollView;

@end

@implementation AdsTableCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // 情景三：图片配文字  这里是3张图片 用的label
    //    NSArray *titles = @[@"文字0",
    //                        @"文字1",
    //                        @"文字2",
    //                        @"文字3"
    //                        ];
    
    //网络加载 --- 创建带标题的图片轮播器
    _sDCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight * HomeCellHeight) imageURLStringsGroup:nil]; // 模拟网络延时情景
    _sDCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sDCycleScrollView.delegate = self;
    //    _sDCycleScrollView.titlesGroup = titles;
    _sDCycleScrollView.currentPageDotColor =  [UIColor yellowColor];
//    _sDCycleScrollView.dotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
    
    _sDCycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    // --- 轮播时间间隔，默认1.0秒，可自定义
    _sDCycleScrollView.autoScrollTimeInterval = 4.0;
    [_adsView addSubview:_sDCycleScrollView];
    
    //  --- 模拟加载延迟
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //    });
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AdsTableCell";
    AdsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
        cell.frame = CGRectMake(0, 5, kUIScreenWidth, kUIScreenHeight*HomeCellHeight);
    }
    // cell 被选中时的风格
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setImgArray:(NSArray *)imgArray {
    
    _imgArray = imgArray;
    _sDCycleScrollView.imageURLStringsGroup = imgArray;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(didAdsSelectItemAtIndex:)]) {
        [self.delegate didAdsSelectItemAtIndex:index];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
