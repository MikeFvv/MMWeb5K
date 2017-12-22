//
//  CarDetailsHeadView.m
//  motoronline
//
//  Created by Mike on 16/2/18.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import "CarDetailsHeadView.h"
#import "CarDetailsHeadCollectionViewCell.h"



static NSString *idenifer = @"CarDetailsHeadCollectionViewCell";


@interface CarDetailsHeadView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowlayout;

@property (nonatomic, strong, nullable)NSMutableArray *arrayButton;

@end

@implementation CarDetailsHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]){
        [self createCollectionView];
    }
    return self;
}

- (NSMutableArray *)arrayButton
{
    if (!_arrayButton) {
        _arrayButton = [NSMutableArray array];
    }
    return _arrayButton;
}

//创建 UICollectionView
- (void)createCollectionView{
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置对齐方式
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    // 左右
    layout.minimumInteritemSpacing = 0;
    // 上下间隔
    layout.minimumLineSpacing = 0;
    
    layout.itemSize = CGSizeMake(kUIScreenWidth, kUIScreenWidth / 375 * 350);
    
    //_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight * 0.39)];   // 这个会崩溃
    //需要layout 否则崩溃：UICollectionView must be initialized with a non-nil layout parameter
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenWidth / 375 * 350) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    //设置不滚动
    _collectionView.scrollEnabled = YES;
    _collectionView.bounces = YES;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionView];
    //注册Cell类，否则崩溃: must register a nib or a class for the identifier or connect a prototype cell in a storyboard
    
    //    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:idenifer];
    
    // 加载xib
    [_collectionView registerNib:[UINib nibWithNibName:idenifer bundle:nil] forCellWithReuseIdentifier:idenifer];
}

- (void)setImagArray:(NSArray *)imagArray {
    
    if (!(imagArray.count > 0)) {
        UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenWidth / 375 * 350)];
        imagView.image = [UIImage imageNamed:@"image_placeholder"];
        [self addSubview:imagView];
        return;
    }

    _imagArray = imagArray;
    [self.collectionView reloadData];
}



- (void)setArrayImageUrl:(NSArray *)arrayImageUrl
{
    if (!(arrayImageUrl.count > 0)) {
        UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenWidth / 375 * 350)];
        imagView.image = [UIImage imageNamed:@"image_placeholder"];
        [self addSubview:imagView];
        return;
    }
    
    _arrayImageUrl = arrayImageUrl;

    _imagArray = arrayImageUrl;
    [self.collectionView reloadData];
}

- (void)buttonClick:(UIButton *)button
{

}


#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger) section {
    YHLog(@"%zd", self.imagArray.count);
    return self.imagArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CarDetailsHeadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idenifer forIndexPath:indexPath];
    
    cell.imagStr = _imagArray[indexPath.row];
    return cell;
}




#pragma mark - 点击评论图片放大查看 代理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self.delegate carDetailsHeadViewCell:collectionView didSelectItemAtIndexPath:indexPath];
}




@end





