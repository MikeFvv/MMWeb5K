//
//  UsedCarDetailsController.m
//  YouCheLian
//
//  Created by Mike on 16/3/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UsedCarDetailsController.h"
#import "UsedCarDetailsHeadCell.h"
#import "UsedCarInfoCell.h"
#import "UsedCarModel.h"
#import "DetailsIntroduceCell.h"
#import "CommentHeaderCell.h"
#import "UsedCarCommentModel.h"
#import "UsedCarCommentModels.h"
#import "UsedCarCommentCell.h"
#import <QuartzCore/CoreAnimation.h>


#import "ZLPhoto.h"
#import "UIImageView+WebCache.h"

#import "LoginViewController.h"
#import "YHNavigationController.h"

#import "UITextView+Select.h"


#define kBottomHeight 48



@interface UsedCarDetailsController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,ZLPhotoPickerBrowserViewControllerDelegate,UsedCarDetailsHeadCellDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UsedCarCommentModels *usedCarCommentModels;
@property (nonatomic, strong) UsedCarCommentModel *usedCarCommentModel;
@property (nonatomic, strong) NSMutableArray *comArray;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) CGFloat viewRowHeight;

@property (nonatomic ,strong) UITextView *bottomTextView;
@property (nonatomic ,strong) UIButton *btn;

@property (nonatomic , strong) NSMutableArray *photos;

@property (nonatomic, assign) NSInteger pageIndex;

//上拉刷新控件
@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshFooter;

@end

@implementation UsedCarDetailsController


//-(void)loadView
//{
//    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight+60)];
//    self.view = _scrollView;
//
//    [self.view addSubview:self.tableView];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self.view addSubview:self.tableView];
    [self initBottomView];
    
    [self getUsedComment];
    [self footerRefresh];
    
    // 注册cell
    [self.tableView registerClass:[UsedCarCommentCell class] forCellReuseIdentifier:@"UsedCarCommentCell"];
    
    
}



-(void)initView {
    self.title = @"二手车详情";
    
    // 添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
}


#pragma mark - 键盘操作
- (void)hidenKeyboard
{   // 点击屏幕键盘消失
    [_bottomTextView resignFirstResponder];
    
}

- (void)setUsedCarModel:(UsedCarModel *)usedCarModel {
    _usedCarModel = usedCarModel;
    _photos = [NSMutableArray array];
    
    NSArray *urlArray = [usedCarModel.imageUrl componentsSeparatedByString:@","];
    
    for (NSInteger i = 0; i < urlArray.count; i++) {
        if (i== urlArray.count -1) {
            break;
        }
        ZLPhotoPickerBrowserPhoto *photo1 = [[ZLPhotoPickerBrowserPhoto alloc] init];
        photo1.photoURL = [NSURL URLWithString:urlArray[i]];
        [_photos addObject:photo1];
    }
    
}




#pragma mark - 搭建界面
- (void)initBottomView {
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor colorWithRed:0.929  green:0.933  blue:0.945 alpha:1];
    _bottomView.layer.cornerRadius = 6;
    _bottomView.layer.masksToBounds = YES;
    
    [self.view addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(kBottomHeight);
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:0.929  green:0.933  blue:0.945 alpha:1];
    [_bottomView addSubview:lineView];
    
    
    _bottomTextView = [[UITextView alloc] init];
    _bottomTextView.font = YHFont(15, NO);
    _bottomTextView.delegate = self;
    _bottomTextView.layer.cornerRadius = 5;
    _bottomTextView.backgroundColor = [UIColor whiteColor];
    
    // 设置内容是否有弹簧效果
    _bottomTextView.alwaysBounceVertical = YES;
    [_bottomView addSubview:_bottomTextView];
    
    
    UIButton *sendBtn = [[UIButton alloc] init];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"send_btn"] forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"send_btn_press"] forState:UIControlStateHighlighted];
    [sendBtn addTarget:self action:@selector(sendMassage) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:sendBtn];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bottomView.mas_top);
        make.left.mas_equalTo(_bottomView.mas_left);
        make.right.mas_equalTo(_bottomView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_bottomView.mas_right).with.offset(-12);
        make.centerY.mas_equalTo(_bottomView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kUIScreenWidth * 0.16, 34));
    }];
    
    
    [_bottomTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bottomView.mas_left).with.offset(10);
        make.right.mas_equalTo(sendBtn.mas_left).with.offset(-10);
        make.centerY.mas_equalTo(_bottomView.mas_centerY);
        make.height.mas_equalTo(34);
    }];
}


#pragma mark - UITextView 代理
- (void)textViewDidChange:(UITextView *)textView {
    
    // 在这个地方计算输入的字数
    #pragma mark 超过200字不能输入
//    NSInteger aa = [textView getInputLengthWithText:nil];
//    YHLog(@"-------%zd", aa);
    if ([textView getInputLengthWithText:nil] > kCharNum) {
        textView.text = [textView.text substringToIndex:kCharNum];
    }
    
    CGFloat textviewH = 0;
    CGFloat minHeight = 34;   // 1行
    CGFloat maxHeight = 106;  // 5行
    
    CGFloat contentHeight = textView.contentSize.height;
    YHLog(@"======%f", contentHeight);
    
    if (contentHeight < minHeight) {
        textviewH = minHeight;
    }else if(contentHeight > maxHeight){
        textviewH = maxHeight;
    }else{
        textviewH = contentHeight;
    }
    
    // 不能换行， 不然会出现大片空白  (开头文字 + 中间换行 + 结尾文字）
    // 按下回车键的时候才走这里
    if ([textView.text hasSuffix:@"\n"]) {
//        NSLog(@"%@",textView.text);
//        textView.text = textView.text;
//        textviewH = minHeight;
        [self.bottomTextView resignFirstResponder];
        
    }
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textviewH+(kBottomHeight - minHeight));
        }];
        
        [self.bottomTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textviewH);
        }];
        
        [self.view layoutIfNeeded];
    }];
    
}



//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    NSInteger textLength = [textView getInputLengthWithText:text];
//    if (textLength > kCharNum) {
//        //超过200个字可以删除
//        if ([text isEqualToString:@""]) {
//            return YES;
//        }
//        return NO;
//    }
//    return YES;
//}


#pragma mark - 发送评论
///  发送评论
- (void)sendMassage {
    // 去除首尾空格和换行 
    NSString *content = [_bottomTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([YHUserInfo shareInstance].isLogin) {  // 是否登录
        if (content == nil || [content isEqualToString:@""]) {
            [self showMessage:@"评论内容不能为空" delay:1];
        } else {
            
            [self sendCommentData];
        }
    } else {  // 没登录  跳转到登录页面
        
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.loginOrReg = YES;
        YHNavigationController *navVc = [[YHNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navVc animated:YES completion:nil];
    }
}



// 发送评论
- (void)sendCommentData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1043" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; // 用户注册手机号
    [dictParam setValue:self.usedCarModel.infoid.stringValue forKey:@"rec_id"]; // 二手车发布信息ID
    [dictParam setValue:_bottomTextView.text forKey:@"rec_content"]; // 评论内容
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@",result);
        if (error) {
            
        } else {
            
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                _bottomTextView.text = @"";
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(kBottomHeight);
                    }];
                    
                    [self.bottomTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(34);
                    }];
                    
                    [self.view layoutIfNeeded];
                }];
                
                
                self.bottomTextView.editable = YES;
                [self getUsedComment];  // 发表评论成功后调用服务器刷新数据
            } else {
                [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            }
        }
        
        return YES;
    }];
}

#pragma mark - 初始化 tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kUIScreenWidth,kUIScreenHeight - kUINavHeight - kBottomHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 隐藏分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        //去掉下面没有数据呈现的cell
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}




#pragma mark UITableView + 上拉刷新 加载更多
- (void)footerRefresh
{
    // 添加默认的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsedData)];
    self.refreshFooter = refreshFooter;
    
    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStatePulling];
    [refreshFooter setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateWillRefresh];
    [refreshFooter setTitle:@"已显示全部内容" forState:MJRefreshStateNoMoreData];
    
    self.tableView.mj_footer = refreshFooter;
}



#pragma mark - 上拉加载更多数据 分页
///获取更多数据
- (void)loadMoreUsedData {
    if (self.comArray.count < self.usedCarCommentModels.res_pageTotalSize) {
        self.pageIndex++;
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1044" forKey:@"rec_code"];
    [dictParam setValue:self.usedCarModel.infoid.stringValue forKey:@"rec_id"]; // 二手车发布信息ID
    
    [dictParam setValue:[NSString stringWithFormat:@"%zd",self.pageIndex] forKey:@"rec_pageIndex"]; // 第几页,默认值1
    [dictParam setValue:@"5" forKey:@"rec_pageSize"]; // 每页多少条，默认值5
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
            
            _usedCarCommentModels = [UsedCarCommentModels mj_objectWithKeyValues:result];
            
            [_comArray addObjectsFromArray:_usedCarCommentModels.dataList];
            // 刷新表格
            [self.tableView reloadData];
            // 拿到当前的上拉刷新控件，结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        return YES;
    }];
}




#pragma mark - 请求数据 评论数据
/// 获取二手车评论数据
- (void)getUsedComment {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1044" forKey:@"rec_code"];
    [dictParam setValue:self.usedCarModel.infoid.stringValue forKey:@"rec_id"]; // 二手车发布信息ID
    [dictParam setValue:@"1" forKey:@"rec_pageIndex"]; // 第几页,默认值1
    [dictParam setValue:@"5" forKey:@"rec_pageSize"]; // 每页多少条，默认值5
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
            
            _usedCarCommentModels = [UsedCarCommentModels mj_objectWithKeyValues:result];
            _comArray = [NSMutableArray arrayWithArray:_usedCarCommentModels.dataList];
            // 刷新表格
            [self.tableView reloadData];
        }
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        return YES;
    }];
}


#pragma mark - TableView数据源
// 多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// 第section分区一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    } else {
        YHLog(@"%zd", self.comArray.count);
        return self.comArray.count;
    }
}


// 设置每行高度 每一行
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return kUIScreenHeight * kHeadCellHeight;  // 140
        } else if (indexPath.row == 1) {
            return _usedCarModel.cellTitleHeight;
        } else if (indexPath.row == 2) {
            return _usedCarModel.cellDescripHeight;
        }else if (indexPath.row == 3) {
            return 40;
        }
    } else {
        UsedCarCommentModel *model = self.comArray[indexPath.row];
        return model.cellHeight;
    }
    
    return 120;
}

#pragma mark - UITableViewCell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UsedCarDetailsHeadCell *cell = [UsedCarDetailsHeadCell cellWithTableView:tableView];
            cell.model =  self.usedCarModel;
            cell.delegate = self;
            
            // 判断类型来获取Image
            if (self.photos.count > 0) {
                ZLPhotoPickerBrowserPhoto *photo = self.photos[indexPath.row];
                [cell.imagView ww_setImageWithString: [NSString stringWithFormat:@"%@",photo.photoURL]  wihtImgName:@"image_placeholder"];
                photo.toView = cell.imagView;
            }
            return cell;
            
        } else if (indexPath.row  == 1) {
            UsedCarInfoCell *cell = [UsedCarInfoCell cellWithTableView:tableView];
            cell.model =  self.usedCarModel;
            return cell;
        } else if (indexPath.row == 2) {
            DetailsIntroduceCell *cell = [DetailsIntroduceCell cellWithTableView:tableView];
            cell.model = self.usedCarModel;
            return cell;
        } else {
            CommentHeaderCell *cell = [CommentHeaderCell cellWithTableView:tableView];
            return cell;
        }
    } else {
        UsedCarCommentCell *cell = [UsedCarCommentCell cellWithTableView:tableView];
        cell.model = self.comArray[indexPath.row];
        return cell;
    }
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    //    UsedCarDetailsController *vc = [[UsedCarDetailsController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didHeaderImageAction {
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 数据源/delegate
    pickerBrowser.delegate = self;
    // 数据源可以不传，传photos数组 photos<里面是ZLPhotoPickerBrowserPhoto>
    pickerBrowser.photos = self.photos;
    // 是否可以删除照片
    pickerBrowser.editing = NO;
    // 当前选中的值
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}

#pragma mark - setupCell click ZLPhotoPickerBrowserViewController

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser didCurrentPage:(NSUInteger)page{
    //    [self.tableView setContentOffset:CGPointMake(0, 95 * page)];
    //   YHLog(@" --- %ld", 95 * page);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
