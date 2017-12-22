//
//  MeMessageViewController.m
//  YouCheLian
//
//  Created by Mike on 16/3/23.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "MeMessageViewController.h"
#import "FlipTableView.h"
#import "SegmentTapView.h"
#import "MeSystemMessageController.h"
#import "FoundSquareViewController.h"
#import "FoundDetailsController.h"
#import "ZLPhoto.h"
#import "FoundSquareModel.h"
#import "CommentCollectionViewCell.h"
#import "MeSystemMessageDetailsController.h"
#import "MeSystemMessageModel.h"

@interface MeMessageViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate,FoundSquareViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,MeSystemMessageControllerDelegate>

@property (nonatomic, strong) SegmentTapView *segment;
@property (nonatomic, strong) FlipTableView *flipView;

@property (nonatomic, strong) MeSystemMessageController *messageVC;
@property (nonatomic, strong) FoundSquareViewController *v2;
@property (nonatomic, strong) FoundSquareViewController *v3;

@property (strong, nonatomic) NSMutableArray *controllsArray;


@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) UICollectionView  *collectionView;

@end

@implementation MeMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSegment];
    
    [self setNav];
    
    [self initFlipTableView];
    
    //    [self getData];
    
    //    self.segment.userInteractionEnabled = NO;
    
    //    [self showLoadingView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}


-(void)initSegment{
    
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 44) withDataArray:[NSArray arrayWithObjects:@"系统信息",@"我发布的",@"我评论的", nil] withFont:16];
    self.segment.lineColor = [UIColor colorWithRed:0.588  green:0.776  blue:0.145 alpha:1];
    self.segment.textSelectedColor = [UIColor blackColor];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    
}

-(void)initFlipTableView{
    if (!self.controllsArray) {
        self.controllsArray = [[NSMutableArray alloc] init];
    }
    
    //添加控制器
    MeSystemMessageController *v1= [[MeSystemMessageController alloc] init];
    v1.delegate = self;
    self.messageVC = v1;
    
    FoundSquareViewController *v2= [[FoundSquareViewController alloc] init];
    v2.squareType = @"1";//我的发现
    v2.delegate = self;
    self.v2 = v2;
    
    FoundSquareViewController *v3= [[FoundSquareViewController alloc] init];
    v3.squareType = @"3";//我评论过的发现
    v3.delegate = self;
    self.v3 = v3;
    
    
    [self.controllsArray addObject:v1];
    [self.controllsArray addObject:v2];
    [self.controllsArray addObject:v3];
    
    
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 44, kUIScreenWidth, kUIScreenHeight - 64 - 44) withArray:_controllsArray];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
}

#pragma  mark - 设置导航栏
- (void)setNav{
    
    self.title = @"消息";
    
    
}

#pragma mark - 查看系统消息记录添加请求
-(void)sendReaedRequest:(MeSystemMessageModel *)model {
    
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1067" forKey:@"rec_code"];
    [dictParam setValue:model.ID forKey:@"rec_id"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"字符串===%@",dictParam);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@",result);
        
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            //设置为已读
            model.isRead = @"1";
            
            [self.messageVC.tableView reloadData];
            
        }else {
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
        }

        return YES;
    }];

}

#pragma mark - MeSystemMessageControllerDelegate
//消息页面跳转
- (void)meSystemMessageController:(MeSystemMessageController *)VC didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MeSystemMessageModel *model = VC.dataArray[indexPath.row];
    
    if ([model.isRead isEqualToString:@"0"]) {//未读消息
        
        //发送已读请求
        [self sendReaedRequest:model];
        
    }
    
    MeSystemMessageDetailsController *detailsVC = [[MeSystemMessageDetailsController alloc] init];
    
    detailsVC.model = model;
    
    [self.navigationController pushViewController:detailsVC animated:YES];
    
    
    
    
}


#pragma mark - FoundSquareViewControllerDelegate
//发现详情页面跳转
- (void)foundSquareViewController:(FoundSquareViewController *)foundSquareVC didSelectRowAtIndexPath:(NSIndexPath *)indexPath withModel:(FoundSquareModel *)model{
    
    FoundDetailsController *vc = [[FoundDetailsController alloc] init];
    vc.ID = model.ID.integerValue;
    vc.isUpvote = model.isUpvote;
    
//    if ([foundSquareVC.squareType isEqualToString:@"3"]) {
//         vc.showDeleteBtn = YES;
//    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}



- (void)FoundSquareViewCell:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imagArray:(NSArray *)imagArray{
    
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    
    // 分割 截取字符串  如果没有图片=0
    //    CarCommentModel *model = imagArray[indexPath.row];
    //    self.commentImagArray2 = [model.imageUrls componentsSeparatedByString:@","];
    
    self.imageArray = imagArray;
    // 数据源/delegate
    // 动画方式
    /*
     *
     UIViewAnimationAnimationStatusZoom = 0, // 放大缩小
     UIViewAnimationAnimationStatusFade , // 淡入淡出
     UIViewAnimationAnimationStatusRotate // 旋转
     pickerBrowser.status = UIViewAnimationAnimationStatusFade;
     */
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    self.collectionView = collectionView;
    // 是否可以删除照片
    pickerBrowser.editing = NO;
    // 当前分页的值
    // pickerBrowser.currentPage = indexPath.row;
    // 传入组
    pickerBrowser.currentIndexPath = indexPath;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
    
    
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section {
    return self.imageArray.count;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath {
    
    
    id imageObj = [self.imageArray objectAtIndex:indexPath.item];
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


#pragma mark -------- select Index
-(void)selectedIndex:(NSInteger)index
{
    NSLog(@"%zd",index);
    [self.flipView selectIndex:index];
    
}
-(void)scrollChangeToIndex:(NSInteger)index
{
    NSLog(@"%zd",index);
    [self.segment selectIndex:index];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
