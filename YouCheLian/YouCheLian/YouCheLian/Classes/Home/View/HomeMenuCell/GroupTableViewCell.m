//
//  DSGroupTableViewCell.m
//  CheLunShiGuang
//
//  Created by Mike on 15/11/7.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import "GroupTableViewCell.h"
#import "GroupCollectionViewCell.h"


static NSString *idenifer = @"GroupCollectionViewCell";
static NSString *ID = @"GroupTableViewCell";

@interface GroupTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowlayout;

@end


@implementation GroupTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格  灰色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [self initialization];
        [self setupMainView];
    }
    return self;
}



/// 当控件从xib或stroyboard中创建的时候调用
- (void)awakeFromNib {
  [super awakeFromNib];
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
    
    flowLayout.itemSize = CGSizeMake((kUIScreenWidth - 2*15) / 4, homeCellHeight);;
    // 左右 
    flowLayout.minimumInteritemSpacing = 0;
    //上下间隔
    flowLayout.minimumLineSpacing = 0;

    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowlayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, (kUIScreenWidth - 2*15), homeCellHeight) collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
//    mainView.backgroundColor = [UIColor whiteColor];
    mainView.pagingEnabled = YES;
    //设置不滚动
    mainView.scrollEnabled = NO;
    
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    [mainView registerClass:[GroupCollectionViewCell class] forCellWithReuseIdentifier:idenifer];
    mainView.dataSource = self;
    mainView.delegate = self;
    [self addSubview:mainView];
    _collectionView = mainView;
    
}


#pragma mark --setCollArray
- (void)setCollArray:(NSArray *)collArray {
    _collArray = collArray;
    [_collectionView reloadData];
}


#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger) section {
    return _collArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idenifer forIndexPath:indexPath];
    
    cell.collModel = _collArray[indexPath.row];
 
    return cell;
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didMenuSelectItemAtIndexPath:)]) {
        [self.delegate didMenuSelectItemAtIndexPath:indexPath];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
