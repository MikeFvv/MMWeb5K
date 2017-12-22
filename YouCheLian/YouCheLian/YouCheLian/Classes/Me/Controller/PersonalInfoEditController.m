//
//  PersonalInfoEditController.m
//  YouCheLian
//
//  Created by Mike on 15/12/4.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "PersonalInfoEditController.h"
#import "UIImage+SuperCompress.h"
#import "UITextView+Select.h"

#import "UIImage+Utils.h"

// 限制最大字符数
#define kMaxLength 16
// 限制最大字符数
#define kMaxAutographLength 60

@interface PersonalInfoEditController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    UIImagePickerController *pickerController;
}

@property(nonatomic, strong) NSData *fileData;
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
// 昵称
@property (weak, nonatomic) IBOutlet UITextField *nicknameField;
// 女
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
// 男
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet UITextField *autographField;

@property (nonatomic, assign) NSInteger sexInt;
// 准备上传的图像
@property (nonatomic, strong) UIImage *userImage;

// 是否有选择图片
@property (nonatomic, assign) BOOL isSelectImage;

@end

@implementation PersonalInfoEditController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initView];
    [self createPickerData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_nicknameField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autographFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_autographField];
    
    [self setPersonalInfoModel:_personalInfoModel];
}




- (IBAction)headImageAction:(UITapGestureRecognizer *)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}




- (void)initView {
    self.title = @"个人资料编辑";
    
    _headImageView.layer.cornerRadius = 100/2;
    _headImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _headImageView.layer.borderWidth = 1;
    _headImageView.clipsToBounds = YES;  // 超出边框的内容都剪掉
    
    
    _femaleBtn.tag = 800;
    _maleBtn.tag = 801;
    
    [_femaleBtn setBackgroundImage:[UIImage imageNamed:@"me_checkBtn"] forState:UIControlStateNormal];
    [_femaleBtn setBackgroundImage:[UIImage imageNamed:@"me_checkBtn_ok"] forState:UIControlStateSelected];
    
    [_maleBtn setBackgroundImage:[UIImage imageNamed:@"me_checkBtn"] forState:UIControlStateNormal];
    [_maleBtn setBackgroundImage:[UIImage imageNamed:@"me_checkBtn_ok"] forState:UIControlStateSelected];
    
    /*----------个性签名----------*/
    _autographField.placeholder = @"个性签名";
    
    _saveBtn.layer.cornerRadius = 5;
    
}


///  保存
- (IBAction)saveBtnAction:(UIButton *)sender {
    
    
    if([[_nicknameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        
        return [self showMessage:@"昵称不能为空" delay:1];
        
    }
    
    if (_femaleBtn.selected == NO && _maleBtn.selected == NO) {
        return [self showMessage:@"请选择性别" delay:1];
    }
    
    if (self.isSelectImage) {
        //照片上传
        [self upDateHeadIcon:self.userImage];
    } else {
        [self setUserData];
    }
    
}

#pragma mark - 保存个人资料
/// 保存个人资料
- (void)setUserData {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1037" forKey:@"rec_code"];
    [dictParam setValue: [YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];
    [dictParam setValue:_nicknameField.text forKey:@"rec_nickName"];
    [dictParam setValue:[NSString stringWithFormat:@"%zd",_sexInt] forKey:@"rec_sex"];
    [dictParam setValue:_autographField.text forKey:@"rec_signature"];
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        if (error) {
            
        } else {
            if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
                
                [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:2];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else {
                [self showMessage:[NSString stringWithFormat:@"%@",result[@"res_desc"]] delay:1];
            }
        }
        return YES;
    }];
}




///  性别选择
- (IBAction)checkBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.tag == 800) {
        _sexInt = 2;
        _maleBtn.selected = NO;
        
    } else if (sender.tag == 801) {
        _sexInt = 1;
        _femaleBtn.selected = NO;
    }
}



#pragma mark - 页面赋值
// 赋值
-(void)setPersonalInfoModel:(PersonalInfoModel *)personalInfoModel {
    _personalInfoModel = personalInfoModel;
    
    [_headImageView ww_setImageWithString:personalInfoModel.uHeadUrl wihtImgName:@"me_Individual_img"];
    
    _nicknameField.text = personalInfoModel.uNickname;
    
    
    if (self.personalInfoModel.uSex.integerValue == 1) { // 男
        _maleBtn.selected = YES;
        _sexInt = 1;
    } else if (self.personalInfoModel.uSex.integerValue == 2) { // 女
        _femaleBtn.selected = YES;
        _sexInt = 2;
    }
    /*-------个性签名--------*/
    _autographField.text = personalInfoModel.uSignature;
}




#pragma mark - 头像上传
- (void)upDateHeadIcon:(UIImage *)userImage
{
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1021" forKey:@"rec_code"];
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"];  // 注册用户号
    
    UIImage *smallImage = [UIImage resizeImage:userImage withNewSize:CGSizeMake(200.0f, 200.0f)];  // 将图片尺寸改为200*200
    
    
    NSData *imageData = UIImagePNGRepresentation(smallImage);
    // base64加密
    NSString *base64String = [imageData base64EncodedStringWithOptions:0];
    [dictParam setValue:base64String forKey:@"rec_myImage"];  // 用户头像二进制流
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];
    
    YHLog(@"%@",[YHFunction dictionaryToJson:dictParam]);
    
    [self showLoadingView];
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        if (error) {
            
        } else {
            YHLog(@"%@",result);
            if ([result[@"res_num"] isEqualToString:@"0"]) {
                ;
                
                // 保存图片
                [UserDefaultsTools setObject:imageData forKey:@"uHeadUrl"];  // 头像保存
                
                [self setUserData];
            }
        }
        
        [self hidenLoadingView];
        return YES;
    }];
}





- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            NSLog(@"支持相机");
            [self makePhoto];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置-->隐私-->相机，中开启本应用的相机访问权限！！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我知道了", nil];
            [alert show];
        }
    }else if (buttonIndex == 1){//相片
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            NSLog(@"支持相册");
            [self choosePicture];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置-->隐私-->照片，中开启本应用的相机访问权限！！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我知道了", nil];
            [alert show];
        }
    }else if (buttonIndex == 3){
        
    }
}


- (void)createPickerData
{
    //初始化pickerController
    pickerController = [[UIImagePickerController alloc]init];
    pickerController.view.backgroundColor = [UIColor orangeColor];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
}


//跳转到imagePicker里
- (void)makePhoto
{
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pickerController animated:YES completion:nil];
}
//跳转到相册
- (void)choosePicture
{
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerController animated:YES completion:nil];
}

//用户取消退出picker时候调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"%@",picker);
    [pickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}





#pragma mark - 用户选中图片之后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        NSString *videoPath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)saveImage:(UIImage *)image {
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(200, 200)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    
    self.headImageView.image = selfPhoto;
    
    
    self.userImage = selfPhoto;
    self.isSelectImage = YES;
}


//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}




-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[textField textInputMode] primaryLanguage];
    //    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}


-(void)autographFiledEditChanged:(NSNotification *)obj {
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[textField textInputMode] primaryLanguage];
    //    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxAutographLength) {
                textField.text = [toBeString substringToIndex:kMaxAutographLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxAutographLength) {
            textField.text = [toBeString substringToIndex:kMaxAutographLength];
        }
    }
}




#pragma mark - 销毁通知
/// 销毁通知
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:_nicknameField];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:_autographField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
