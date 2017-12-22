//
//  FoundReleaseViewController.m
//  YouCheLian
//
//  Created by Mike on 16/3/17.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FoundReleaseViewController.h"
#import "ReleaseCollectionViewCell.h"
#import "ZLPhoto.h"
#import "UIImage+SuperCompress.h"

#import "ZLPhotoActionSheet.h"

#define kMaxLength 300

@interface FoundReleaseViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ReleaseCollectionViewCellDeleagate,ZLPhotoPickerViewControllerDelegate,UITextViewDelegate>

@property (nonatomic, strong) UICollectionView *collectView;

@property (nonatomic, strong) NSMutableArray *assets;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) NSMutableArray *imageArray;
//上传照片临时存放
@property (nonatomic, assign) int count;

@property (nonatomic, strong) ZLPhotoActionSheet *actionSheet;

@end

@implementation FoundReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNav];
    
    [self initView];
    
    self.assets = [NSMutableArray arrayWithObject:[UIImage imageNamed:@"Found_add_photos_2"]];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    // 相册
    self.actionSheet = [[ZLPhotoActionSheet alloc] init];
    
    //设置照片最大预览数
    self.actionSheet.maxPreviewCount = 20;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - setter && getter

-(NSMutableArray *)imageArray{
    
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

#pragma mark - 发送 网络请求
///发送发现请求
- (void)releaseSquareRequest {
    
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1070" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:self.textView.text forKey:@"rec_content"];
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    [dictParam setValue:self.imageArray forKey:@"rec_imageDataList"]; // 图片列表
    
    [self showLoadingViewWithText:[NSString stringWithFormat:@"正在发布"]];
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        YHLog(@"%@",result);
        [self hidenLoadingView];
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            
            [self showMessage:result[@"res_desc"] delay:1.0];
            
            if ([self.delegate respondsToSelector:@selector(foundReleaseViewControllerReleaseSucceed)]){
                [self.delegate foundReleaseViewControllerReleaseSucceed];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            
//            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            
        }
        
        return YES;
    }];
}





///发现上传图片请求
- (void)squareUploadImageData {
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
    
    
    // 判断类型来获取Image
    //图片数据
    ZLPhotoAssets *icon = self.assets[self.count + 1];
    
    UIImage *image = nil;
    
    if ([icon isKindOfClass:[ZLPhotoAssets class]]) {
        image = [icon originImage];
    }else if([icon isKindOfClass:[UIImage class]]){
        image = (UIImage *)icon;
    }else if ([icon isKindOfClass:[ZLCamera class]]){
        image = ((ZLCamera *)icon).photoImage;
    }
    
    //    NSData *data = UIImagePNGRepresentation(image);
    
    // 规定上传图片尺寸  宽度
    NSData *iconData = [UIImage compressImage:image toMaxLength:512*1024*100 maxWidth:800];
    
    NSString *imageStr = [iconData base64EncodedStringWithOptions:0];
    [imageDict setValue:imageStr forKey:@"imageData"];
    
    [imageList addObject: imageDict];
    
    
    [dictParam setValue:imageList forKey:@"rec_imageDataList"]; // 图片列表
    
    [self showLoadingViewWithText:[NSString stringWithFormat:@"正在上传第%d张图片",self.count +1]];
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        YHLog(@"%@",result);
        [self hidenLoadingView];
        if ([result[@"res_num"] isEqualToString:@"0"]) { // 成功
            
            NSArray *array = result[@"dataList"];
            [self.imageArray addObject:array[0]];
            
            if (self.count < self.assets.count - 1 - 1) {
                self.count++;
                [self squareUploadImageData];
                
            }else {
                
                [self releaseSquareRequest];
                //                [self showMessage:result[@"res_desc"] delay:1.0];
                
            }
            
            
        }else {
            
//            [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            
        }
        
        return YES;
    }];
}



#pragma mark - 初始化View

- (void)initView {
    //初始化视图
    UIView *conentView = [[UIView alloc] init];
    //    conentView.frame = CGRectMake(0, 0, kUIScreenWidth, 185);
    conentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:conentView];
    self.contentView = conentView;
    
    [conentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(185);
        make.top.mas_equalTo(self.view.mas_top);
    }];
    
    //uitextView
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(15, 15, kUIScreenWidth - 30, 105);
    textView.font = [UIFont systemFontOfSize:20];
    textView.delegate = self;
    [conentView addSubview:textView];
    self.textView = textView;
    
    
    
    //选中照片列表
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(50, 50);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectView.backgroundColor = [UIColor whiteColor];
    collectView.dataSource = self;
    collectView.delegate = self;
    collectView.showsHorizontalScrollIndicator = NO;
    [conentView addSubview:collectView];
    self.collectView = collectView;
    
    //注册对应的collectionCell
    [collectView registerNib:[UINib nibWithNibName:@"ReleaseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ReleaseCollectionViewCell"];
    
    [collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(conentView.mas_left).offset(15);
        make.right.mas_equalTo(conentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(conentView.mas_bottom).offset(-15);
        make.height.mas_equalTo(50);
    }];
    
    
    
}

#pragma mark - 设置导航栏
- (void)initNav {
    //发布按钮
    // 搜索
    UIButton *releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    releaseBtn.frame = CGRectMake(0, 0, 50, 28);
    releaseBtn.layer.cornerRadius = 28 / 2;
    
    [releaseBtn setBackgroundColor:[UIColor colorWithRed:0.588  green:0.776  blue:0.145 alpha:1]];
    [releaseBtn setTitle:@"发布" forState:UIControlStateNormal];
    releaseBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [releaseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [releaseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [releaseBtn addTarget:self action:@selector(releaseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseBtn];
}

//发布按钮点击
- (void)releaseBtnClick {
    
    if([[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        
        return [self showMessage:@"请输入内容或者图片" delay:1];
        
    }else{
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        //上传图片
        if (self.assets.count > 1){  //  + 号算一张图片
            [self squareUploadImageData];
        }else{
            [self releaseSquareRequest];
        }
        
    }
    
}

#pragma mark - collectionDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ReleaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReleaseCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row == self.assets.count - 1){
        cell.image = self.assets[0];
        cell.deleteBtnHidden = YES;
    }else{
        // 判断类型来获取Image
        UIImage *asset = self.assets[indexPath.row + 1];
        cell.image = asset;
        cell.deleteBtnHidden = NO;
    }
    
    cell.delegate = self;
    cell.contentView.layer.borderWidth = 1;
    cell.contentView.layer.borderColor = [UIColor colorWithRed:0.561  green:0.769  blue:0.122 alpha:1].CGColor;
    cell.indexPath = indexPath;
    
    return cell;
    
}

#pragma mark -  点击加号按钮 选择图片
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.assets.count - 1){
        
        if (self.assets.count < 10) {
//            // 创建控制器
//            ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
//            // 默认显示相册里面的内容SavePhotos
//            // 最多能选9张图片
//            pickerVc.topShowPhotoPicker = YES;
//            pickerVc.status = PickerViewShowStatusCameraRoll;
//            pickerVc.delegate = self;
//            pickerVc.maxCount = 10 - self.assets.count;
//            [pickerVc showPickerVc:self];
            
            
            __weak typeof(self) weakSelf = self;
            
            //设置照片最大选择数
            self.actionSheet.maxSelectCount = 9 - (self.assets.count - 1);
            
            [self.actionSheet showWithSender:self animate:YES completion:^(NSArray<UIImage *> * _Nonnull selectPhotos) {

                [weakSelf.assets addObjectsFromArray:selectPhotos];
                
                [weakSelf.collectView reloadData];
                
                //滑动界面到加号
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:weakSelf.assets.count - 1 inSection:0];
                [weakSelf.collectView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
                
            }];

            
        }else{
            [self showMessage:@"最多选择9张图片" delay:1.0];
        }
        
        
        
    }
    
}
#pragma mark - 相册回调
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets{
    
    
    [self.assets addObjectsFromArray:assets];
    [self.collectView reloadData];
    
    
}



#pragma mark -

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *toBeString = textView.text;
    NSString *lang = [[textView textInputMode] primaryLanguage];
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textView.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textView.text = [toBeString substringToIndex:kMaxLength];
        }
    }
    
    return YES;
}



#pragma mark - ReleaseCollectionViewCellDeleagate

- (void)releaseCollectionViewCellDidClickDeleteBtn:(ReleaseCollectionViewCell *)cell {
    
    [self.assets removeObjectAtIndex:self.assets.count - 1 - cell.indexPath.row];
    
    [self.collectView reloadData];
    
}

@end
