//
//  CarCommentCell.m
//  motoronline
//
//  Created by Mike on 16/1/26.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import "CarCommentCell.h"
#import "CarCommentModel.h"
#import "CommentCollectionViewCell.h"
#import "ZLPhoto.h"
#import <UIImageView+WebCache.h>

static NSString *idenifer = @"CommentCollectionViewCell";

@interface CarCommentCell()<UICollectionViewDataSource,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;

@property (weak, nonatomic) IBOutlet UIImageView *imagView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;

@property (nonatomic,strong) NSArray *imagArray;

@end

@implementation CarCommentCell

/// 当控件从xib或stroyboard中创建的时候调用
- (void)awakeFromNib {
    [super awakeFromNib];
    // 加载xib
    [_collectionView registerNib:[UINib nibWithNibName:idenifer bundle:nil] forCellWithReuseIdentifier:idenifer];
    
    //设置不滚动
    _collectionView.scrollEnabled = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    // 左右
    _flowlayout.minimumInteritemSpacing  = 0;
    //上下间隔
    _flowlayout.minimumLineSpacing = 8;
    
    _flowlayout.itemSize = CGSizeMake((kUIScreenWidth-68- 2*8)/3, 90);
    
}





+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CarCommentCell";
    CarCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格  灰色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(CarCommentModel *)model {
    _model = model;
    // 分割 截取字符串  如果没有图片=0
    self.imagArray = [model.imageUrls componentsSeparatedByString:@","];
    
    
    [_imagView ww_setImageWithString:model.headUrl wihtImgName:@"rec_headImage"];
    
    _titleLabel.text = model.nickName;
    _contentLabel.text = model.content;
    _timeLabel.text = model.addTime;
    _colorLabel.text =[NSString stringWithFormat:@"颜色分类：%@",model.oderRemark];
}



#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger) section {
    YHLog(@"%zd", self.imagArray.count);
    return self.imagArray.count;
    
}

#pragma mark - 点击评论图片放大查看 代理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(carCommentCellCell:didSelectItemAtIndexPath:imagArray:)]) {
        [self.delegate carCommentCellCell:collectionView didSelectItemAtIndexPath:indexPath imagArray:self.imagArray];
    }
    
    //    MJPhotoBrowser *browserVc = [[MJPhotoBrowser alloc] init];
    //    NSMutableArray *images = [NSMutableArray array];
    //
    //    for (int i = 0; i < self.imagArray.count; i++) {
    //
    //        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
    //        CommentCollectionViewCell *cell = (CommentCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //
    //        NSString *imageUrl = [self.imagArray[i] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //
    //        MJPhoto *photo = [[MJPhoto alloc] init];
    //        photo.url = [NSURL URLWithString:imageUrl];
    //        photo.image = cell.imagView.image;   //  image 对象
    //        photo.srcImageView = cell.imagView;  //  来源视图 image对象
    //
    //        photo.save = NO;
    //        photo.index = (int)indexPath.row;
    //
    //        [images addObject:photo];
    //    }
    //
    //    browserVc.photos = images;
    //    browserVc.currentPhotoIndex = indexPath.row;
    //    //    browserVc.delegate = self;
    //    [browserVc show];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idenifer forIndexPath:indexPath];
    cell.imagStr = self.imagArray[indexPath.row];
    
    // 判断类型来获取Image
    ZLPhotoAssets *asset = self.imagArray[indexPath.row];
    if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
        cell.imagView.image = [asset aspectRatioImage];
    }else if ([asset isKindOfClass:[NSString class]]){
        
        [cell.imagView sd_setImageWithURL:[NSURL URLWithString:(NSString *)asset] placeholderImage:[UIImage imageNamed:@"occupyingImage"]];
        
    }else if([asset isKindOfClass:[UIImage class]]){
        cell.imagView.image = (UIImage *)asset;
    }else if ([asset isKindOfClass:[ZLCamera class]]){
        cell.imagView.image = [asset thumbImage];
    }
    
    return cell;
    
}


#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return [self.imagArray count];
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    id imageObj = [self.imagArray objectAtIndex:indexPath.row];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    CommentCollectionViewCell *cell = (CommentCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    // 缩略图
    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
        photo.asset = imageObj;
    }
    photo.toView = cell.imagView;
    photo.thumbImage = cell.imagView.image;
    return photo;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
