//
//  FoundSquareCommentCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/17.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FoundSquareCommentCell.h"
#import "FoundSquareModel.h"
#import "FoundDetailsModel.h"
#import "CommentCollectionViewCell.h"
#import "ZLPhoto.h"
#import <UIImageView+WebCache.h>

static NSString *idenifer = @"CommentCollectionViewCell";

@interface FoundSquareCommentCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;

@property (weak, nonatomic) IBOutlet UIImageView *imagView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;



@property (nonatomic,strong) NSArray *imagArray;


@end

@implementation FoundSquareCommentCell

- (IBAction)commentNumBtn:(id)sender {
    
    
}
- (IBAction)deleteBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(FoundSquareCommentCellDidClickDeleteBtn:withModel:)]) {
        [self.delegate FoundSquareCommentCellDidClickDeleteBtn:sender withModel:self.model];
    }
    
}

- (IBAction)UpvoteNumAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(FoundSquareCommentCellDidClickUpvoteNumBtn:withModel:)]) {
        [self.delegate FoundSquareCommentCellDidClickUpvoteNumBtn:sender withModel:self.model];
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // 加载xib
    [_collectionView registerNib:[UINib nibWithNibName:idenifer bundle:nil] forCellWithReuseIdentifier:idenifer];
    
    CGFloat imageWidth = (kUIScreenWidth - 88 - 2 * 10) / 3;
    CGFloat imageHetght = imageWidth;
    
    //设置不滚动
    _collectionView.scrollEnabled = YES;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    // 左右
    _flowlayout.minimumInteritemSpacing  = 10;
    //上下间隔
    _flowlayout.minimumLineSpacing = 10;
    
    _flowlayout.itemSize = CGSizeMake(imageWidth, imageHetght);
    
    //设置头像圆形
    self.imagView.layer.cornerRadius = 24;
    self.imagView.layer.borderWidth = 1;
    self.imagView.layer.borderColor = [UIColor colorWithRed:0.561  green:0.765  blue:0.129 alpha:1].CGColor;
    self.imagView.clipsToBounds = YES;
    
    
    
}



+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FoundSquareCommentCell";
    FoundSquareCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    // cell 被选中时的风格  灰色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(FoundSquareModel *)model {
    _model = model;
    // 分割 截取字符串  如果没有图片=0
//    self.imagArray = [model.imageUrls componentsSeparatedByString:@","];
    self.imagArray = model.lstImage;
    [_imagView ww_setImageWithString:model.userImg wihtImgName:@"Found_protrait"];
    _titleLabel.text = model.userNickname;
    _contentLabel.text = model.content;
    _timeLabel.text = model.publishTime;
    
    if (!model.isUpvote) {//未点赞
        _upvoteNumBtn.selected = NO;
    }else if(model.isUpvote) { //已点赞
        _upvoteNumBtn.selected = YES;
    }
    
    [_commentNumBtn setTitle:[NSString stringWithFormat:@"%d",model.commentNum] forState:UIControlStateNormal];
    [_upvoteNumBtn setTitle:[NSString stringWithFormat:@"%d",model.upvoteNum] forState:UIControlStateNormal];
    
    [self.collectionView reloadData];

    
}


- (void)setDataModel:(FoundDetailsModel *)dataModel{
    _dataModel = dataModel;
    // 分割 截取字符串  如果没有图片=0
    //    self.imagArray = [model.imageUrls componentsSeparatedByString:@","];
    self.imagArray = dataModel.dataList;
    [_imagView ww_setImageWithString:dataModel.userImg wihtImgName:@"Found_protrait"];
    _titleLabel.text = dataModel.userNickname;
    _contentLabel.text = dataModel.content;
    _timeLabel.text = dataModel.publishTime;
    [_commentNumBtn setTitle:[NSString stringWithFormat:@"%d",dataModel.commentNum] forState:UIControlStateNormal];
    [_upvoteNumBtn setTitle:dataModel.upvoteNum forState:UIControlStateNormal];
    
    [self.collectionView reloadData];
    
}



#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger) section {
    YHLog(@"%zd", self.imagArray.count);
    return self.imagArray.count;
    
}

#pragma mark - 点击评论图片放大查看 代理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(foundSquareCommentCellCell:didSelectItemAtIndexPath:imagArray:)]) {
        [self.delegate foundSquareCommentCellCell:collectionView didSelectItemAtIndexPath:indexPath imagArray:self.imagArray];
    }
    
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idenifer forIndexPath:indexPath];
    
    FoundSquareImageModel *model = self.imagArray[indexPath.row];
    cell.imagStr = model.imageData;
    [cell.imagView ww_setImageWithString:model.imageData wihtImgName:@"image_placeholder"];
    
    return cell;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
