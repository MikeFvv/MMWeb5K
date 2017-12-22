//
//  DiscountCarCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/31.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "DiscountCarCell.h"
#import "DiscountCarCollectionCell.h"




static NSString *idenifer = @"DiscountCarCollectionCell";
static NSString *ID = @"DiscountCarCell";

@interface DiscountCarCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowlayout;

@end


@implementation DiscountCarCell

/// 当控件从xib或stroyboard中创建的时候调用
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        [self setupMainView];
//    }
//    return self;
//}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"DiscountCarCell";
    DiscountCarCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DiscountCarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupMainView];
    }
    return self;
}

// 设置显示图片的collectionView
- (void)setupMainView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat homeCellHeight;
    if (IS_IPHONE4) {
        homeCellHeight = HomeMenuCellHeight;
    } else if (IS_IPHONE5) {
        homeCellHeight = HomeMenuCellHeight;
    }else if (IS_IPHONE6) {
        homeCellHeight = HomeMenuCellHeight + 5;
    }else if (IS_IPHONE6_PLUS) {
        homeCellHeight = HomeMenuCellHeight + 10;
    }else {
        homeCellHeight = HomeMenuCellHeight;
    }
    
    flowLayout.itemSize = CGSizeMake((kUIScreenWidth - 2*15) / 2, DisCarCellHeight);;
    // 左右
    flowLayout.minimumInteritemSpacing = 0;
    //上下间隔
    flowLayout.minimumLineSpacing = 0;
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowlayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, (kUIScreenWidth - 2*15), DisCarCellHeight) collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
    //    mainView.backgroundColor = [UIColor whiteColor];
    mainView.pagingEnabled = YES;
    //设置不滚动
    mainView.scrollEnabled = NO;
    
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    [mainView registerClass:[DiscountCarCollectionCell class] forCellWithReuseIdentifier:idenifer];
    mainView.dataSource = self;
    mainView.delegate = self;
    [self addSubview:mainView];
    _collectionView = mainView;
    
}


#pragma mark --setCollArray
- (void)setCellArray:(NSArray *)cellArray {
    _cellArray = cellArray;
    [_collectionView reloadData];
}


#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger) section {
    return _cellArray.count > 2 ? 2 : _cellArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscountCarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idenifer forIndexPath:indexPath];
    
    cell.model = _cellArray[indexPath.row];
    return cell;
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectedDiscountCarCell:)]) {
        [self.delegate didSelectedDiscountCarCell:indexPath.row];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


@end
