
//  CarDetailsSubViewController.m
//  motoronline
//
//  Created by Mike on 16/1/29.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import "CarDetailsSubViewController.h"


#import "CarDetailsSubViewDataModel.h"
#import "ContentViewController.h"
#import "SpecificationsViewController.h"
#import <MJExtension.h>




@interface CarDetailsSubViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate,/*EvaluationListViewControllerDelegate,*/ContentViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *controllsArray;
@property (nonatomic, strong) CarDetailsSubViewDataModel *dataModel;
@property (nonatomic, strong) ContentViewController *contentVC;
@property (nonatomic, strong) SpecificationsViewController *SpecificationsVC;

@end

@implementation CarDetailsSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSegment];
    
    [self setNav];
    
    self.segment.userInteractionEnabled = NO;
    
    if (![self.type isEqualToString:@"0"]) {
        [self getData];
    }else{
        self.segment.userInteractionEnabled = YES;
        [self initFlipTableView];
    }
    
    
    
    [self showLoadingView];
    
    
}

-(void)setSpec:(NSString *)spec{
    _spec = spec;
    //    [self.SpecificationsVC.webView loadHTMLString:spec baseURL:nil];
    self.SpecificationsVC.htmlStr = spec;
    [self hidenLoadingView];
    
}

-(void)setDesc:(NSString *)desc{
    _desc = desc;
    
    self.contentVC.htmlStr = desc;
    [self hidenLoadingView];
}



-(void)initSegment{
    //    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, 40) withDataArray:[NSArray arrayWithObjects:@"图文详情",@"规格参数",@"评价", nil] withFont:16];
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, 40) withDataArray:[NSArray arrayWithObjects:@"图文详情",@"规格参数", nil] withFont:16];
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
    ContentViewController *v1= [[ContentViewController alloc] init];
    v1.htmlStr = self.dataModel.content;
    v1.delegate = self;
    self.contentVC = v1;
    
    SpecificationsViewController *v2 = [[SpecificationsViewController alloc] init];
    v2.htmlStr = self.dataModel.specifications;
    self.SpecificationsVC = v2;
    v2.delegate = self;
    
    
    
    [self.controllsArray addObject:v1];
    [self.controllsArray addObject:v2];
    
    
    
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 104, kUIScreenWidth, self.view.frame.size.height - 104) withArray:_controllsArray];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
}

///  评论下拉刷新代理
- (void)downRefreshEvaluation {
    if ([self.delegate respondsToSelector:@selector(carDetailsSubDownRefresh)]) {
        [self.delegate carDetailsSubDownRefresh];
    }
}

- (void)downRefreshContent {
    if ([self.delegate respondsToSelector:@selector(carDetailsSubDownRefresh)]) {
        [self.delegate carDetailsSubDownRefresh];
    }
}

//// 评价图片放大
//- (void)carEvaluationCellCell:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imagArray:(NSArray *)imagArray {
//
//    if ([self.delegate respondsToSelector:@selector(carEvaluationCellCell:didSelectItemAtIndexPath:imagArray:)]) {
//        [self.delegate carEvaluationCellCell:collectionView didSelectItemAtIndexPath:indexPath imagArray:imagArray];
//    }
//}


#pragma  mark - 请求数据
/// 获取推荐车型商品描述数据
- (void)getData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1059" forKey:@"rec_code"];
    [dictParam setValue:self.carId forKey:@"rec_id"]; // 商品Id
    [dictParam setValue:self.type forKey:@"rec_type"]; // 1=新车，2=活动车
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    YHLog(@"字符串===%@",dictParam);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@",result);
        self.dataModel = [CarDetailsSubViewDataModel mj_objectWithKeyValues:result];
        
        [self initFlipTableView];
        self.segment.userInteractionEnabled = YES;
        //        [self.flipView.tableView reloadData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        // [self.tableView.mj_footer endRefreshing];
        
        [self hidenLoadingView];
        return YES;
    }];
}


#pragma  mark - 设置导航栏
- (void)setNav{
    self.title = @"商品详情";
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_another"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];
    
    
    
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_home_another"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackHome:)];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    // 显示隐藏导航栏
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.086  green:0.706  blue:0.325 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

-(void)onBackBtn:(UIButton *)sender {
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;//可更改为其他方式
    transition.subtype = kCATransitionFromBottom;//可更改为其他方式
    transition.duration = 1;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    
    // 在push控制器时显示UITabBar
    self.hidesBottomBarWhenPushed = NO;
    // 将栈顶的控制器移除
    [self.navigationController popViewControllerAnimated:YES];
}

///  返回首页
-(void)onBackHome:(id)sender {
    // 在push控制器时显示UITabBar
    self.hidesBottomBarWhenPushed = NO;
    self.navigationController.navigationBarHidden = YES;
    // 将栈顶的控制器移除
    [self.navigationController popToViewController:(UIViewController *)self.navigationController.viewControllers[1] animated:YES];
}

#pragma mark -------- select Index
-(void)selectedIndex:(NSInteger)index
{
    //    NSLog(@"%ld",index);
    [self.flipView selectIndex:index];
    
}
-(void)scrollChangeToIndex:(NSInteger)index
{
    //    NSLog(@"%ld",index);
    [self.segment selectIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
