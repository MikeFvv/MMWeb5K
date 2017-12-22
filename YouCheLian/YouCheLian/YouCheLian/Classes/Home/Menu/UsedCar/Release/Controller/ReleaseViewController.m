//
//  ReleaseViewController.m
//  YouCheLian
//
//  Created by Mike on 16/3/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ReleaseViewController.h"
#import "ReleaseImportTableViewCell.h"
#import "ReleaseSelectTableViewCell.h"
#import "ReleaseMultiImportTableViewCell.h"
#import "ReleaseViewModel.h"
#import "ReleaseCollectionViewCell.h"
#import "ReleaseGroupViewController.h"
#import "ReleaseGroupModel.h"
#import "ReleaseBrandViewController.h"
#import "YHPickerViewController.h"
#import "CityOneModel.h"
#import "CityTwoModel.h"
#import "CityThreeModel.h"
#import "UIImage+SuperCompress.h"

#import "NSString+RegexCategory.h"


#import "ZLPhotoActionSheet.h"
#import "ZLShowBigImage.h"

@interface ReleaseViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ReleaseCollectionViewCellDeleagate,ReleaseGroupViewControllerDelegate,ReleaseBrandViewControllerDelegate,YHPickerViewControllerDelegate,ReleaseMultiImportTableViewCellDelegate,UITextFieldDelegate>{
    ZLPhotoActionSheet *actionSheet;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) NSMutableArray *assets;

@property (nonatomic, strong) UICollectionView *collectView;

@property (nonatomic, assign) int height;

@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) UIButton *uploadBtn;

@property (nonatomic, strong) UIButton *smallSelectBtn;

@property (nonatomic, strong) UIButton *releaseBtn;


//model
//分类model
@property (nonatomic, strong) ReleaseGroupModel *groupModel;

@property (nonatomic, strong) ReleaseGroupModel *brandModel;

@property (nonatomic, assign) NSInteger row1;

@property (nonatomic, assign) NSInteger row2;

@property (nonatomic, assign) NSInteger row3;

@property (nonatomic, strong) NSArray *cityArray;

//请求随机码
@property (nonatomic, assign) int rand;
//照片删除按钮是否显示
@property (nonatomic, assign) BOOL deleteBtnHidden;
//上传照片临时存放 当前上传了多少张图片
@property (nonatomic, assign) int count;

//当前的图片
@property (nonatomic, strong) NSMutableArray *currentImages;
//将要添加的图片
@property (nonatomic, strong) NSMutableArray *addImages;
//删除的图片
@property (nonatomic, strong) NSMutableArray *deleteImages;
//已上传的图片
@property (nonatomic, strong) NSMutableArray *uploadImages;


// 描述cell的高度
@property (nonatomic, assign) CGFloat descCellHeight;
@property (nonatomic, copy) NSString *descTextView;

@property (nonatomic, assign) BOOL isNewAdd;

@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.deleteBtnHidden = NO;
    
    //设置导航栏
    [self initNav];
    //初始化视图
    [self initView];
    //初始化
    if (self.model) {
        //设置图片显示
        self.uploadBtn.hidden = NO;
        self.smallSelectBtn.hidden = NO;
        self.collectView.hidden = NO;
        self.selectBtn.hidden = YES;
        
        [self changeHeaderViewHeight];
    }
    
    self.descCellHeight = 40;
    
    
    // 相册
    actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大选择数
    actionSheet.maxSelectCount = 9;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = 20;
}





#pragma mark - 添加图片  按钮点击方法
- (void)selectBtnClick {
    
    actionSheet.maxSelectCount = 9-self.assets.count;
    
    __weak typeof(self) weakSelf = self;
    
    [actionSheet showWithSender:self animate:YES completion:^(NSArray<UIImage *> * _Nonnull selectPhotos) {
#pragma mark - 相册回调
        [weakSelf.assets addObjectsFromArray:selectPhotos];
        
        if (weakSelf.selectBtn.hidden == NO) {
            
            weakSelf.selectBtn.hidden = YES;
            weakSelf.uploadBtn.hidden = NO;
            weakSelf.smallSelectBtn.hidden = NO;
            weakSelf.collectView.hidden = NO;
        }
        
        // 改变头部视图的高度
        [weakSelf changeHeaderViewHeight];
        
        [weakSelf.tableView reloadData];
        [weakSelf.collectView reloadData];
        
    }];
    
}


#pragma mark - 编辑状态赋值
-(void)setModel:(UsedCarModel *)model{
    _model = model;
    
    self.groupModel.name = model.typeText;
    self.groupModel.ID = model.type;
    
    self.brandModel.name = model.brandText;
    self.brandModel.ID = model.brand;
    
    //设置描述
    self.descTextView = model.descrip;
    
    //设置图片
    NSArray *urlArray = [model.imageUrl componentsSeparatedByString:@","];
    //当前图片
    [self.currentImages addObjectsFromArray:urlArray];
    //移除最后多余的空白照片
    [self.currentImages removeObjectAtIndex:(self.currentImages.count - 1)];
    
    [self.assets addObjectsFromArray:self.currentImages];
    
    
    
    //设置地区行数
    for (int i = 0; i < self.cityArray.count; i++) {
        CityOneModel *model1 = self.cityArray[i];
        if ([model.Provinceid isEqualToString:model1.pId]) {
            self.row1 = i;
            for (int j = 0; j < model1.citylist.count; j++) {
                
                CityTwoModel *model2 = model1.citylist[j];
                if ([model.Cityid isEqualToString:model2.cId]) {
                    self.row2 = j;
                    
                    for (int k = 0 ; k < model2.arealist.count; k++) {
                        CityThreeModel *model3 = model2.arealist[k];
                        if ([model.areaid isEqualToString:model3.aId]) {
                            self.row3 = k;
                            break;
                        }
                    }
                    break;
                }
            }
            break;
            
        }
    }
    
}

#pragma mark - 设置导航栏

- (void)initNav {
    
    if (self.model == nil) {
        self.title = @"发布";
    }else {
        self.title = @"二手车编辑";
    }
    
}

#pragma mark - 初始化视图
- (void) initView {
    
    //初始化tableView
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    //底部发布视图
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 60)];
    
    UIButton *releaseBtn = [[UIButton alloc] init];
    if (self.model == nil) {
        [releaseBtn setBackgroundImage:[UIImage imageNamed:@"release_release"] forState:UIControlStateNormal];
    }else {
        [releaseBtn setBackgroundImage:[UIImage imageNamed:@"release_modifyBtn"] forState:UIControlStateNormal];
    }
    
    [releaseBtn addTarget:self action:@selector(releaseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:releaseBtn];
    self.releaseBtn = releaseBtn;
    
    [releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottom.mas_centerX);
        make.centerY.mas_equalTo(bottom.mas_centerY);
        make.width.mas_equalTo(139);
        make.height.mas_equalTo(36);
    }];
    
    self.bottomView = bottom;
    self.tableView.tableFooterView = bottom;
    
    //头部展示视图
    [self setupHeadView];
    
    
}




#pragma mark - collectionDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ReleaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReleaseCollectionViewCell" forIndexPath:indexPath];
    
    
    id asset = self.assets[indexPath.row];
    if ([asset isKindOfClass:[UIImage class]]) {
        cell.image = self.assets[indexPath.row];
        
    } else if([asset isKindOfClass:[NSString class]]){
        [cell.iconView ww_setImageWithString:self.assets[indexPath.row]];
    }
    
    cell.delegate = self;
    cell.deleteBtnHidden = self.deleteBtnHidden;
    cell.indexPath = indexPath;
    
    return cell;
    
    
    
}

#pragma mark - ReleaseCollectionViewCellDeleagate

- (void)releaseCollectionViewCellDidClickDeleteBtn:(ReleaseCollectionViewCell *)cell {
    
    if ([self.currentImages containsObject:self.assets[cell.indexPath.row]]) {
        
        [self.deleteImages addObject:self.assets[cell.indexPath.row]];
    }
    
    [self.assets removeObjectAtIndex:cell.indexPath.row];
    
    //改变头部视图的高度
    [self changeHeaderViewHeight];
    [self.collectView reloadData];
    [self.tableView reloadData];
}

#pragma mark - 上传按钮  上传图片

- (void)uploadBtnClick {
    
    if (self.assets.count < 3){
        
        [self showMessage:@"至少选择3张图片" delay:1.0];
        
    }else{
        
        //编辑状态需要上传的图片
        self.addImages =  [NSMutableArray arrayWithArray:self.assets];
        [self.addImages removeObjectsInArray:self.currentImages];
        //编辑状态上传图片
        if (self.model ) {
            if (self.addImages.count != 0) {
                [self editUploadImageData];
            }else{
                //更新界面
                [self.smallSelectBtn removeFromSuperview];
                [self.uploadBtn removeFromSuperview];
                
                //设置头部删除按钮状态
                self.deleteBtnHidden = YES;
                
                //图片行数
                int row = (((int)self.assets.count - 1) / 3 + 1);
                //图片高度
                CGFloat imageHeight = (kUIScreenWidth - 4 * 15) / 3;
                //头部视图的高度
                self.height = 15 + 15 +  (self.assets.count == 0 ? 30 : (row * imageHeight + (row - 1) * 15));
                
                UIView *headerView = self.tableView.tableHeaderView;
                [self.collectView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(headerView.mas_bottom).offset(-15);
                }];
                
                [headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(self.height);
                }];
                headerView.height = self.height;
                self.tableView.tableHeaderView = headerView;
                
                // 刷新表格
                [self.tableView reloadData];
                [self.collectView reloadData];
                
            }
            
        }else{
            //发布状态上传图片
            //创建零时随机唯一码
            self.rand = arc4random() % 1000000000;
            //发送图片上传请求
            [self uploadImageRequest];
        }
        
        
    }
}






//改变头部视图的高度
- (void)changeHeaderViewHeight{
    //图片行数
    int row = (((int)self.assets.count - 1) / 3 + 1);
    //图片高度
    CGFloat imageHeight = (kUIScreenWidth - 4 * 15) / 3;
    //头部视图的高度
    self.height = 15 + 15 + 15 + 15 + 36 + 36 +  (self.assets.count == 0 ? 30 : (row * imageHeight + (row - 1) * 15));
    
    UIView *headerView = self.tableView.tableHeaderView;
    
    [headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.height);
    }];
    headerView.height = self.height;
    self.tableView.tableHeaderView = headerView;
    
}


#pragma mark - 发布按钮点击方法

- (void)releaseBtnClick {
    
    //编辑状态需要上传的图片
    self.addImages =  [NSMutableArray arrayWithArray:self.assets];
    [self.addImages removeObjectsInArray:self.currentImages];
    
    if (self.deleteImages.count == 0 && self.addImages.count == 0 && self.model != nil) {
        //更新界面
        [self.smallSelectBtn removeFromSuperview];
        [self.uploadBtn removeFromSuperview];
        
        //设置头部删除按钮状态
        self.deleteBtnHidden = YES;
        
        //图片行数
        int row = (((int)self.assets.count - 1) / 3 + 1);
        //图片高度
        CGFloat imageHeight = (kUIScreenWidth - 4 * 15) / 3;
        //头部视图的高度
        self.height = 15 + 15 +  (self.assets.count == 0 ? 30 : (row * imageHeight + (row - 1) * 15));
        
        UIView *headerView = self.tableView.tableHeaderView;
        [self.collectView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(headerView.mas_bottom).offset(-15);
        }];
        
        [headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.height);
        }];
        headerView.height = self.height;
        self.tableView.tableHeaderView = headerView;
        
        // 刷新表格
        [self.tableView reloadData];
        [self.collectView reloadData];
        
    }
    
    //上传图片
    if (self.uploadBtn.superview != nil) {
        
        [self showMessage:@"请先上传图片" delay:1.0];
        
    }else if([[[self getCellContentTextFieldTextWith:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        
        [self showMessage:@"请填写标题" delay:1.0];
        
    }else if (self.groupModel == nil){
        
        [self showMessage:@"请选择分类" delay:1.0];
        
    }else if (self.brandModel == nil){
        
        [self showMessage:@"请选择品牌" delay:1.0];
        
    }else if([[self getCellContentTextFieldTextWith:3] isEqualToString:@""]) {
        
        [self showMessage:@"请填写价格" delay:1.0];
        
    }else if (self.row1 == -1 || self.row2 == -1 || self.row3 == -1){
        
        [self showMessage:@"请选择地区" delay:1.0];
        
    }else if([[self getCellContentTextFieldTextWith:5] isEqualToString:@""]) {
        
        [self showMessage:@"请填写联系人" delay:1.0];
        
    }else if([[self getCellContentTextFieldTextWith:6] isEqualToString:@""]) {
        
        [self showMessage:@"请填写联系电话" delay:1.0];
        
    }else if([self.descTextView isEqualToString:@""]) {
        
        [self showMessage:@"请填写详细描述" delay:1.0];
        
    }else{
        
        //【判断手机号码是否正确
        if (![[self getCellContentTextFieldTextWith:6] isMobileNumber]) {
            [self showMessage:@"联系电话格式不正确" delay:1.0];
            return;
        }
        
        if (self.model != nil) {
            
            //发送修改请求
            [self sendReleaseEditRequest];
            
            return;
        }
        
        //发送发布请求
        [self sendReleaseRequest];
    }
}

#pragma mark - 发送发布请求
//发布请求
- (void)sendReleaseRequest {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1041" forKey:@"rec_code"];
    
    [dictParam setValue:[self getCellContentTextFieldTextWith:0] forKey:@"rec_title"];//标题
    [dictParam setValue:@"0" forKey:@"rec_id"]; // infoID=0为新增，如果infoID不为0为修改
    
    [dictParam setValue:self.releaseType forKey:@"rec_kind"]; // 商品类别编码（如：摩托车，电动车。《数据字典中的Dic_ID》
    [dictParam setValue:self.groupModel.ID forKey:@"rec_type"]; // 分类编码(数据字典中的Dic_ID)
    [dictParam setValue:[self getCellContentTextFieldTextWith:3] forKey:@"rec_price"]; // 价格
    [dictParam setValue:self.brandModel.ID forKey:@"rec_brand"]; // 品牌(数据字典中的dic_id)
    
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; // string	13	发布用户
    
    [dictParam setValue:self.descTextView forKey:@"rec_description"]; // 详细描述
    
    CityOneModel *model1 = self.cityArray[self.row1];
    [dictParam setValue:model1.pId forKey:@"rec_provinceid"]; // 省份Id
    
    CityTwoModel *model2 = model1.citylist[self.row2];
    [dictParam setValue:model2.cId forKey:@"rec_cityid"]; // 城市Id
    
    CityThreeModel *model3 = model2.arealist[self.row3];
    [dictParam setValue:model3.aId forKey:@"rec_areaid"]; // 区域Id
    
    [dictParam setValue:[self getCellContentTextFieldTextWith:6] forKey:@"rec_newUserPhone"]; // 联系电话
    
    [dictParam setValue:[self getCellContentTextFieldTextWith:5]  forKey:@"rec_contactName"]; // 联系人
    [dictParam setValue:[NSString stringWithFormat:@"%d",self.rand] forKey:@"rec_rand"]; // 临时随机唯一码（跟图片上传的rec_rand一致）
    
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [self showLoadingViewWithText:@"发布中"];
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        [self hidenLoadingView];
        YHLog(@"%@",result);
        
        if([result[@"res_num"] isEqualToString:@"0"]){
            
            [self showMessage:@"发布成功" delay:1.0];
            
            if (self.releaseSuccessBlock) {
                self.releaseSuccessBlock();
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
            
            [self showMessage:result[@"res_desc"]  delay:1.0];
            
        }
        
        
        
        return YES;
    }];
    
    
}

#pragma mark - 修改 编辑请求
// 编辑请求
- (void)sendReleaseEditRequest {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1045" forKey:@"rec_code"];
    
    [dictParam setValue:[self getCellContentTextFieldTextWith:0] forKey:@"rec_title"];//标题
    [dictParam setValue:self.model.infoid.stringValue forKey:@"rec_id"]; // infoID=0为新增，如果infoID不为0为修改
    
    [dictParam setValue:self.releaseType forKey:@"rec_kind"]; // 商品类别编码（如：摩托车，电动车。《数据字典中的Dic_ID》
    [dictParam setValue:self.groupModel.ID forKey:@"rec_type"]; // 分类编码(数据字典中的Dic_ID)
    [dictParam setValue:[self getCellContentTextFieldTextWith:3] forKey:@"rec_price"]; // 价格
    [dictParam setValue:self.brandModel.ID forKey:@"rec_brand"]; // 品牌(数据字典中的dic_id)
    
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; // string	13	发布用户
    
    [dictParam setValue:self.descTextView forKey:@"rec_description"]; // 详细描述
    
    CityOneModel *model1 = self.cityArray[self.row1];
    [dictParam setValue:model1.pId forKey:@"rec_provinceid"]; // 省份Id
    
    CityTwoModel *model2 = model1.citylist[self.row2];
    [dictParam setValue:model2.cId forKey:@"rec_cityid"]; // 城市Id
    
    CityThreeModel *model3 = model2.arealist[self.row3];
    [dictParam setValue:model3.aId forKey:@"rec_areaid"]; // 区域Id
    
    [dictParam setValue:[self getCellContentTextFieldTextWith:6] forKey:@"rec_newUserPhone"]; // 联系电话
    
    [dictParam setValue:[self getCellContentTextFieldTextWith:5]  forKey:@"rec_contactName"]; // 联系人
    
    //要删除的图片
    NSMutableString *deleteStr = [NSMutableString string];
    for (NSString *iconUrl in self.deleteImages) {
        [deleteStr appendFormat:@"%@|",iconUrl];
    }
    
    [dictParam setValue:deleteStr forKey:@"rec_imageIds"]; // 删除的照片
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    [dictParam setValue:self.uploadImages forKey:@"rec_imageDataList"];//新增照片
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [self showLoadingViewWithText:@"修改中"];
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        [self hidenLoadingView];
        YHLog(@"%@",result);
        
        if([result[@"res_num"] isEqualToString:@"0"]){
            
            [self showMessage:@"修改成功" delay:1.0];
            //
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
            
            [self showMessage:result[@"res_desc"]  delay:1.0];
            
        }
        
        
        
        return YES;
    }];
    
    
}

#pragma mark - 上传图片
/// 编辑状态上传图片请求
- (void)editUploadImageData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1071" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    NSMutableArray *imageList = [NSMutableArray array];
    
    
    NSMutableDictionary *imageDict =[NSMutableDictionary dictionary];
    
    
    
    int timeScamp = [[NSDate date]timeIntervalSince1970];
    int random = arc4random() % 100;
    NSString *ID = [NSString stringWithFormat:@"%d%d",timeScamp,random];
    
    [imageDict setValue:ID forKey:@"id"];


    id icon = self.addImages[self.count];
    UIImageView *imageView = [[UIImageView alloc] init];
    if ([icon isKindOfClass:[UIImage class]]) {
        imageView.image = icon;
        
    } else if([icon isKindOfClass:[NSString class]]){
        [imageView ww_setImageWithString:icon];
    }
    
    // 规定上传图片尺寸  宽度
    NSData *iconData = [UIImage compressImage:imageView.image toMaxLength:512*1024*200 maxWidth:1200];
    
    NSString *imageStr = [iconData base64EncodedStringWithOptions:0];
    [imageDict setValue:imageStr forKey:@"imageData"];
    
    [imageList addObject: imageDict];
    
    
    [dictParam setValue:imageList forKey:@"rec_imageDataList"]; // 图片列表
    
    [self showLoadingViewWithText:[NSString stringWithFormat:@"正在上传新增的第%d张图片",self.count +1]];
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        [self hidenLoadingView];
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            
            NSArray *array = result[@"dataList"];
            [self.uploadImages addObject:array[0]];
            
            if (self.count < self.addImages.count - 1) {
                
                self.count++;
                [self editUploadImageData];
                
                
            }else{
                [self showMessage:result[@"res_desc"] delay:1.0];
                
                //更新界面
                [self.smallSelectBtn removeFromSuperview];
                [self.uploadBtn removeFromSuperview];
                
                //设置头部删除按钮状态
                self.deleteBtnHidden = YES;
                
                //图片行数
                int row = (((int)self.assets.count - 1) / 3 + 1);
                //图片高度
                CGFloat imageHeight = (kUIScreenWidth - 4 * 15) / 3;
                //头部视图的高度
                self.height = 15 + 15 +  (self.assets.count == 0 ? 30 : (row * imageHeight + (row - 1) * 15));
                
                UIView *headerView = self.tableView.tableHeaderView;
                [self.collectView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(headerView.mas_bottom).offset(-15);
                }];
                
                [headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(self.height);
                }];
                headerView.height = self.height;
                self.tableView.tableHeaderView = headerView;
                
                // 刷新表格
                [self.tableView reloadData];
                [self.collectView reloadData];
            }
            
            
        }else {
            
            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            
        }
        
        return YES;
    }];
}


//发送上传图片的请求
- (void)uploadImageRequest {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1042" forKey:@"rec_code"];
    
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; // string	13	发布用户
    
    [dictParam setValue:[NSString stringWithFormat:@"%d",self.rand] forKey:@"rec_rand"]; // 临时随机唯一码（跟图片上传的rec_rand一致）
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    NSMutableArray *imageList = [NSMutableArray array];
    
    
    NSMutableDictionary *imageDict =[NSMutableDictionary dictionary];
    [imageDict setValue:[NSString stringWithFormat:@"%d",self.count + 1] forKey:@"id"];
    
    id icon = self.addImages[self.count];
    UIImageView *imageView = [[UIImageView alloc] init];
    if ([icon isKindOfClass:[UIImage class]]) {
        imageView.image = icon;
        
    } else if([icon isKindOfClass:[NSString class]]){
        [imageView ww_setImageWithString:icon];
    }
    
    // 规定上传图片尺寸  宽度
    NSData *iconData = [UIImage compressImage:imageView.image toMaxLength:512*1024*200 maxWidth:1200];
    
    NSString *imageStr = [iconData base64EncodedStringWithOptions:0];
    [imageDict setValue:imageStr forKey:@"imageData"];
    
    [imageList addObject: imageDict];
    
    
    [dictParam setValue:imageList forKey:@"rec_imageDataList"]; // 图片列表
    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    
    [self showLoadingViewWithText:[NSString stringWithFormat:@"正在上传第%d张图片",self.count +1]];
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        
        [self hidenLoadingView];
        if([result[@"res_num"] isEqualToString:@"0"]){
            
            
            if (self.count < self.assets.count - 1) {
                self.count++;
                [self uploadImageRequest];
            }else {
                [self showMessage:result[@"res_desc"] delay:1.0];
                
                //更新界面
                [self.smallSelectBtn removeFromSuperview];
                [self.uploadBtn removeFromSuperview];
                
                //设置头部删除按钮状态
                self.deleteBtnHidden = YES;
                
                //图片行数
                int row = (((int)self.assets.count - 1) / 3 + 1);
                //图片高度
                CGFloat imageHeight = (kUIScreenWidth - 4 * 15) / 3;
                //头部视图的高度
                self.height = 15 + 15 +  (self.assets.count == 0 ? 30 : (row * imageHeight + (row - 1) * 15));
                
                UIView *headerView = self.tableView.tableHeaderView;
                [self.collectView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(headerView.mas_bottom).offset(-15);
                }];
                
                [headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(self.height);
                }];
                headerView.height = self.height;
                self.tableView.tableHeaderView = headerView;
                
                // 刷新表格
                [self.tableView reloadData];
                [self.collectView reloadData];
            }
            
            
        }else{
            
            [self showMessage:result[@"res_desc"]  delay:1.0];
            
        }
        
        
        return YES;
    }];
    
    
    
    
}

#pragma mark - 获得Cell中的textField字符串
// 获得Cell中的textField字符串
- (NSString *)getCellContentTextFieldTextWith:(NSInteger)row {
    [self.tableView reloadData];
    if (row == 7) {
        return @"";
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    ReleaseImportTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSString *str = cell.contentTextFiled.text;
    YHLog(@"%@",str);
    
    return cell.contentTextFiled.text;
}

//设置Cell中的textField字符串

- (void)setCellContentTextFieldTextWith:(NSInteger)row andStr:(NSString *)str{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    ReleaseImportTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.contentTextFiled.text = str;
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    YHLog(@"%ld",textField.tag);
    
    if (textField.tag == 1001) {
        
        self.model.title = textField.text;
        
    }else if (textField.tag == 1002){
        
        self.model.price = textField.text;
        
    }else if (textField.tag == 1003){
        
        self.model.contactName = textField.text;
        
    }else if (textField.tag == 1004){
        
        self.model.contact_Phone = textField.text;
        
    }
    
}

#pragma mark - UITableViewDataSource代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReleaseBaseTableViewCell *cell = nil;
    ReleaseViewModel *model = self.dataArray[indexPath.row];
    
    if (model.cellType == ReleaseViewCellTypeImport) {
        cell = [ReleaseImportTableViewCell cellWithTableView:tableView];
        ((ReleaseImportTableViewCell *)cell).indexPath = indexPath;
        ((ReleaseImportTableViewCell *)cell).contentTextFiled.delegate = self;
        //当model不为空时，说明当前为编辑状态，初始化数据
        if (self.model != nil) {
            
            if (indexPath.row == 0) {
                ((ReleaseImportTableViewCell *)cell).contentTextFiled.text = self.model.title;
                ((ReleaseImportTableViewCell *)cell).contentTextFiled.tag = 1001;
            }else if (indexPath.row == 3){
                ((ReleaseImportTableViewCell *)cell).contentTextFiled.text = self.model.price;
                ((ReleaseImportTableViewCell *)cell).contentTextFiled.tag = 1002;
            }else if (indexPath.row == 5){
                ((ReleaseImportTableViewCell *)cell).contentTextFiled.text = self.model.contactName;
                ((ReleaseImportTableViewCell *)cell).contentTextFiled.tag = 1003;
            }else if (indexPath.row == 6){
                ((ReleaseImportTableViewCell *)cell).contentTextFiled.text = self.model.contact_Phone;
                ((ReleaseImportTableViewCell *)cell).contentTextFiled.tag = 1004;
            }
            
        }
        
        
    }else if (model.cellType == ReleaseViewCellTypeSelect){
        cell = [ReleaseSelectTableViewCell cellWithTableView:tableView];
        if (indexPath.row == 1) {
            ((ReleaseSelectTableViewCell *)cell).contentLabel.text = self.groupModel.name;
        }else if (indexPath.row == 2) {
            ((ReleaseSelectTableViewCell *)cell).contentLabel.text = self.brandModel.name;
        }else if (indexPath.row == 4) {
            
            if (_cityArray != nil) {
                CityOneModel *model1 = self.cityArray[self.row1];
                CityTwoModel *model2 = model1.citylist[self.row2];
                CityThreeModel *model3 = model2.arealist[self.row3];
                
                NSString *str = nil;
                if([model1.provinceName isEqualToString:model2.cityName] && [model1.provinceName isEqualToString:model3.areaName]) {
                    str = [NSString stringWithFormat:@"%@",model1.provinceName];
                }else if ([model1.provinceName isEqualToString:model2.cityName]) {
                    str = [NSString stringWithFormat:@"%@%@",model1.provinceName,model3.areaName];
                }else{
                    str = [NSString stringWithFormat:@"%@%@%@",model1.provinceName,model2.cityName,model3.areaName];
                }
                
                ((ReleaseSelectTableViewCell *)cell).contentLabel.text = str;
            }
            
        }
        
        
    }else if (model.cellType == ReleaseViewCellTypeMutilImport){
        // 商品描述
        cell = [ReleaseMultiImportTableViewCell cellWithTableView:tableView];
        ((ReleaseMultiImportTableViewCell *)cell).delegate = self;
        ((ReleaseMultiImportTableViewCell *)cell).textView.text = self.descTextView;
        
    }
    
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate代理方法
//返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 7) {
        //        ReleaseViewModel *model = self.dataArray[indexPath.row];
        //        return model.cellHeight;
        return 100;
    }
    return 40;
}



//选择方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1){
        NSString *fileName = nil;
        if ([self.releaseType isEqualToString:@"10007"]) {
            //摩托车分类
            fileName = @"motoClass.plist";
        }else if([self.releaseType isEqualToString:@"10008"]){
            //电动车分类
            fileName = @"diandongClass.plist";
        }
        
        ReleaseGroupViewController *vc = [[ReleaseGroupViewController alloc] init];
        vc.dataArray = [ReleaseGroupModel GetmodelDataWithPlistFileName:fileName];
        vc.delegate = self;
        [self.navigationController  pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 2){
        
        NSString *fileName = nil;
        if ([self.releaseType isEqualToString:@"10007"]) {
            //摩托车品牌
            fileName = @"motoBrand.plist";
        }else if([self.releaseType isEqualToString:@"10008"]){
            //电动车品牌
            fileName = @"carBrand.plist";
        }
        
        ReleaseBrandViewController *vc = [[ReleaseBrandViewController alloc] init];
        vc.dataArray = [ReleaseGroupModel GetmodelDataWithPlistFileName:fileName];
        vc.delegate = self;
        [self.navigationController  pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 4){
        
        self.tableView.userInteractionEnabled = NO;
        //地址选择器
        YHPickerViewController *vc = [[YHPickerViewController alloc] init];
        vc.dataArray = self.cityArray;
        vc.delegate = self;
        [vc show];
    }
    
}


#pragma mark - YHPickerViewControllerDelegate

- (void)pickerViewControllerDidClickSureBtnWithRow1:(NSInteger)row1 andRow2:(NSInteger)row2 andRow3:(NSInteger)row3 {
    
    self.row1 = row1;
    self.row2 = row2;
    self.row3 = row3;
    [self.tableView reloadData];
    
}

- (void)pickerViewControllerDisappear {
    
    self.tableView.userInteractionEnabled = YES;
    
}


#pragma mark - ReleaseGroupViewControllerDelegate

- (void)releaseGroupViewControllerWithModel:(ReleaseGroupModel *)model{
    
    self.groupModel = model;
    [self.tableView reloadData];
    
}


#pragma mark - ReleaseGroupViewControllerDelegate

- (void)ReleaseBrandViewControllerWithModel:(ReleaseGroupModel *)model{
    
    self.brandModel = model;
    [self.tableView reloadData];
    
}

#pragma mark - 商品描述 textView 输入字符变化代理

-(void)releaseMultiImportTableViewTextView:(UITextView *)textView CellChangeTextFieldText:(NSString *)text {
    // 获取商品描述的值
    self.descTextView = textView.text;
    
    //    CGFloat textviewH = 0;
    //    CGFloat minHeight = 40;
    //    CGFloat maxHeight = 90;
    
    //    CGFloat contentHeight = textView.contentSize.height;
    //    if (contentHeight <minHeight) {
    //        textviewH = minHeight;
    //    }else if(contentHeight>maxHeight){
    //        textviewH = maxHeight;
    //    }else{
    //        textviewH = textView.contentSize.height;
    //    }
    //
    //
    //    if (contentHeight > self.descCellHeight) {
    //        self.descCellHeight = textviewH;
    //        [self.tableView beginUpdates];
    //        [self.tableView endUpdates];
    //    }
    
    
    
    //    [self.tableView reloadData];
    //    [textView becomeFirstResponder];
    
}


#pragma mark - setter && getter
- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [ReleaseViewModel modelData];
    }
    return _dataArray;
}

- (NSMutableArray *)assets{
    if (!_assets) {
        
        _assets = [NSMutableArray array];
    }
    return _assets;
}

- (ReleaseGroupModel *)groupModel {
    if (!_groupModel) {
        
        _groupModel = [[ReleaseGroupModel alloc] init];
    }
    return _groupModel;
}

- (ReleaseGroupModel *)brandModel {
    if (!_brandModel) {
        
        _brandModel = [[ReleaseGroupModel alloc] init];
    }
    return _brandModel;
}

- (NSArray *)cityArray {
    if (!_cityArray) {
        
        _cityArray = [CityOneModel mj_objectArrayWithFilename:@"citydata.plist"];
    }
    return _cityArray;
}

- (NSMutableArray *)currentImages{
    if (!_currentImages) {
        _currentImages = [NSMutableArray array];
    }
    return _currentImages;
}

- (NSMutableArray *)addImages{
    if (!_addImages) {
        _addImages = [NSMutableArray array];
    }
    return _addImages;
}

- (NSMutableArray *)deleteImages{
    if (!_deleteImages) {
        _deleteImages = [NSMutableArray array];
    }
    return _deleteImages;
    
    
}
- (NSMutableArray *)uploadImages{
    if (!_uploadImages) {
        _uploadImages = [NSMutableArray array];
    }
    return _uploadImages;
    
}


- (void)setupHeadView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 15 + 15 + 15 + 15 + 36 + 36 + 60)];
    self.headerView = headerView;
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kUIScreenWidth);
        make.height.mas_equalTo(15 + 15 + 15 + 15 + 36 + 36 + 60);
    }];
    
    //大的选择图片按钮
    UIButton *selectBtn = [[UIButton alloc] init];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"release_uploadPicture"] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:selectBtn];
    self.selectBtn = selectBtn;
    
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(headerView.mas_top).offset(15);
        make.left.mas_equalTo(headerView.mas_left).offset(15);
        make.right.mas_equalTo(headerView.mas_right).offset(-15);
        make.bottom.mas_equalTo(headerView.mas_bottom).offset(-15);
        
    }];
    
    //确认上传按钮
    UIButton *uploadBtn = [[UIButton alloc] init];
    uploadBtn.hidden = YES;
    [uploadBtn setBackgroundImage:[UIImage imageNamed:@"release_uploadBtn"] forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:uploadBtn];
    self.uploadBtn = uploadBtn;
    
    [uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.bottom.mas_equalTo(headerView.mas_bottom).offset(- 15);
        make.width.mas_equalTo(175);
        make.height.mas_equalTo(36);
    }];
    
    //小的选择图片按钮
    UIButton *smallSelectBtn = [[UIButton alloc] init];
    smallSelectBtn.hidden = YES;
    [smallSelectBtn setBackgroundImage:[UIImage imageNamed:@"release_smallUpload"] forState:UIControlStateNormal];
    [smallSelectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:smallSelectBtn];
    self.smallSelectBtn = smallSelectBtn;
    
    [smallSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(headerView.mas_left).offset(15);
        make.right.mas_equalTo(headerView.mas_right).offset(-15);
        make.bottom.mas_equalTo(uploadBtn.mas_top).offset(-15);
        make.height.mas_equalTo(36);
        
    }];
    
    //计算照片高度宽度
    CGFloat margin = 15;
    CGFloat imageWidth = (kUIScreenWidth - 4 * margin) / 3;
    CGFloat imageHeight = imageWidth;
    
    //选中照片列表
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(imageWidth, imageHeight);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectView.hidden = YES;
    
    collectView.dataSource = self;
    collectView.delegate = self;
    collectView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:collectView];
    self.collectView = collectView;
    
    //注册对应的collectionCell
    [collectView registerNib:[UINib nibWithNibName:@"ReleaseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ReleaseCollectionViewCell"];
    
    [collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left).offset(15);
        make.right.mas_equalTo(headerView.mas_right).offset(-15);
        make.bottom.mas_equalTo(smallSelectBtn.mas_top).offset(-15);
        make.top.mas_equalTo(headerView.mas_top).offset(15);
    }];
    
    //分隔线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.3;
    [headerView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(headerView.mas_left);
        make.right.mas_equalTo(headerView.mas_right);
        make.bottom.mas_equalTo(headerView.mas_bottom);
        
    }];
    
    self.tableView.tableHeaderView = headerView;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
