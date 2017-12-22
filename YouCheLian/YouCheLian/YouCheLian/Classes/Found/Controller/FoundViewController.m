//
//  FoundViewController.m
//  YouCheLian
//
//  Created by Mike on 15/11/4.
//  Copyright © 2015年 Mike. All rights reserved.
//

#define  ISScreenWidth     [UIScreen mainScreen].bounds.size.width
#define  ISScreenHeight    [UIScreen mainScreen].bounds.size.height

#define baidu @"http://www.baidu.com/"

#import "FoundViewController.h"
#import "DVSwitch.h"
#import "FoundShopViewController.h"
#import "FoundSquareViewController.h"
#import "FoundReleaseViewController.h"
#import "ZLPhoto.h"
#import "CommentCollectionViewCell.h"
#import "ShopDetailsTableController.h"
#import "SearchModel.h"
#import "FoundDetailsController.h"

#import "LoginViewController.h"
#import "YHNavigationController.h"
#import "FoundSquareModel.h"


@interface FoundViewController ()<UIScrollViewDelegate,FoundShopViewControllerDelegate,FoundSquareViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,FoundReleaseViewControllerDelegate>


@property (nonatomic, strong) UIButton *releaseBtn;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) FoundShopViewController *foundShopVC;

@property (nonatomic, strong) FoundSquareViewController *foundSquareVC;

@property (nonatomic, strong) DVSwitch *dvSwitch;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) UICollectionView  *collectionView;


@end

@implementation FoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setNav];
    //初始化View
    [self initView];
    //将要出现时获取数据
    [self.foundSquareVC getSquareData];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //将要出现时获取数据
//    [self.foundSquareVC getSquareData];
    
}

#pragma mark - 初始化View

- (void)initView {
    
    //初始化scrollView
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.frame = self.view.frame;
    self.scrollView.contentSize = CGSizeMake(kUIScreenWidth * 2 , kUIScreenHeight - kUITabBarHeight - 44 - 20);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    

    FoundShopViewController *vc = [[FoundShopViewController alloc] init];
    vc.view.frame = CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight - kUITabBarHeight - 64);
    vc.delegate = self;
    self.foundShopVC = vc;
    [self.scrollView addSubview:vc.view];
    
    
    FoundSquareViewController *vc2 = [[FoundSquareViewController alloc] init];
    vc2.view.frame = CGRectMake(kUIScreenWidth, 0, kUIScreenWidth, kUIScreenHeight - kUITabBarHeight - 64);
    vc2.delegate = self;
    vc2.squareType = @"2";//发现列表
    self.foundSquareVC = vc2;
    [self.scrollView addSubview:vc2.view];
    
    
    
    
}
#pragma mark - 设置导航栏
- (void)setNav {
    // 自定义标题
    self.title = @"发现";
    
    //中间的分段选择器
    DVSwitch *switcher = [[DVSwitch alloc] initWithStringsArray:@[@"附近商家", @"广场"]];
    switcher.layer.borderWidth = 1;
    switcher.layer.borderColor = [UIColor colorWithRed:0.561  green:0.769  blue:0.122 alpha:1].CGColor;
    switcher.layer.cornerRadius = 26 / 2;
    switcher.frame = CGRectMake(0,0,140, 26);
    switcher.sliderOffset = 0;
    switcher.cornerRadius = 26 / 2;
    switcher.font = [UIFont systemFontOfSize:14];
    switcher.labelTextColorOutsideSlider = [UIColor darkGrayColor];
    switcher.labelTextColorInsideSlider = [UIColor whiteColor];
    switcher.backgroundColor = [UIColor whiteColor];
    switcher.sliderColor = [UIColor colorWithRed:0.561  green:0.769  blue:0.122 alpha:1];
    [self.view addSubview:switcher];
    self.dvSwitch = switcher;
    
    [switcher setPressedHandler:^(NSUInteger index) {
        
        NSLog(@"Did press position on first switch at index: %lu", (unsigned long)index);
        if (index == 1) {
            self.releaseBtn.hidden = NO;
            [self.scrollView setContentOffset:CGPointMake(kUIScreenWidth, 0) animated:YES];
        }else{
            self.releaseBtn.hidden = YES;
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
    }];
    self.navigationItem.titleView = switcher;
    
    
    //发布按钮
    // 搜索
    UIButton *releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    releaseBtn.frame = CGRectMake(0, 0, 44, 44);
    [releaseBtn setTitle:@"发布" forState:UIControlStateNormal];
    releaseBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [releaseBtn setTitleColor:[UIColor colorWithRed:0.588  green:0.776  blue:0.145 alpha:1] forState:UIControlStateNormal];
    [releaseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [releaseBtn addTarget:self action:@selector(releaseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    releaseBtn.hidden = YES;
    self.releaseBtn = releaseBtn;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseBtn];
    
}

#pragma mark - 商家跳转
-(void)didSelectJumpFoundShopDelegateModel:(SearchModel *)model {
    // 商家详情
    ShopDetailsTableController *vc = [[ShopDetailsTableController alloc] init];
    [vc setHidesBottomBarWhenPushed:YES];
    vc.title = model.merchName;
    vc.shopId = model.ID.stringValue;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 广场 发布入口
//发布按钮点击
- (void)releaseBtnClick {
    
    if ([YHUserInfo shareInstance].isLogin) {  // 是否登录
        FoundReleaseViewController *vc = [[FoundReleaseViewController  alloc] init];
        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = YES; 
        [self.navigationController pushViewController:vc animated:YES];
    } else {  // 没登录  跳转到登录页面
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.loginOrReg = YES;
        YHNavigationController *navVc = [[YHNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navVc animated:YES completion:nil];
    }
}

#pragma mark - UIScrollViewDelegate - 子类重写
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;{
    if (self.scrollView.contentOffset.x < kUIScreenWidth ) {
        [self.dvSwitch selectIndex:0 animated:YES];
        self.releaseBtn.hidden = YES;
    }else {
        [self.dvSwitch selectIndex:1 animated:YES];
        self.releaseBtn.hidden = NO;
    }
    
}

#pragma mark - FoundReleaseViewControllerDelegate
//发布成功后重新加载数据
- (void)foundReleaseViewControllerReleaseSucceed {
    [self.foundSquareVC getSquareData];
}

#pragma mark - FoundSquareViewControllerDelegate
//发现详情页面跳转
- (void)foundSquareViewController:(FoundSquareViewController *)foundSquareVC didSelectRowAtIndexPath:(NSIndexPath *)indexPath withModel:(FoundSquareModel *)model{

    FoundDetailsController *vc = [[FoundDetailsController alloc] init];
    vc.ID = model.ID.integerValue;
    vc.isUpvote = model.isUpvote;
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
