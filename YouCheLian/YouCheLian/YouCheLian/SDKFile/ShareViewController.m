//
//  ShareViewController.m
//  WheelTime
//
//  Created by Mike on 16/1/18.
//  Copyright © 2016年 微微. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareBtn.h"


#define animateDuration  0.3
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ShareViewController ()<WXApiDelegate>

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *imageNameArray;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, assign) CGFloat toolHeight;

@property (nonatomic, assign) CGFloat shareBtnHeight;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.titleArray = @[@"微信好友",@"微信朋友圈",@"微信收藏"];
    self.imageNameArray = @[@"share_Wechat",@"share_friends",@"share_collection"];
    self.shareBtnHeight = 100;
    
    //初始化界面
    [self initView];
    
    //showButtomView
    [self showButtomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)showButtomView{
    [UIView animateWithDuration:animateDuration animations:^{
        self.bottomView.frame = CGRectMake(0, kUIScreenHeight - self.toolHeight, kUIScreenWidth, self.toolHeight);
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    
}
//初始化界面
- (void)initView{
    
    //遮盖按钮
    UIButton *coverBtn = [[UIButton alloc] init];
    [coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [coverBtn setBackgroundColor:[UIColor blackColor]];
    coverBtn.alpha = 0.3;
    [self.view addSubview:coverBtn];
    

  
    //总列数
    int totalCol = 3;
    self.toolHeight = self.shareBtnHeight * ((self.titleArray.count - 1) / totalCol + 1) + 50;
    //底部视图
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,kUIScreenHeight, kUIScreenWidth, self.toolHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    //按钮尺寸
    CGFloat width = ScreenWidth / totalCol;
    
    //设置按钮
    for (int i = 0; i < self.titleArray.count; i++) {
        //当前行数
        int row = i / totalCol;
        //当前列数
        int col = i % totalCol;
        
        ShareBtn *shareBtn = [[ShareBtn alloc] init];
        
        [shareBtn setImage:[UIImage imageNamed:self.imageNameArray[i]] forState:UIControlStateNormal];
        shareBtn.tag = 10000 + i;
        shareBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [shareBtn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [bottomView addSubview:shareBtn];
        
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bottomView.mas_top).offset(self.shareBtnHeight * row);
            make.left.mas_equalTo(self.view.mas_left).offset(width * col);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(self.shareBtnHeight);
        }];
        
    }
    //取消按钮
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancleBtn.layer.cornerRadius = 5;
    cancleBtn.layer.borderWidth = 1;
    cancleBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancleBtn];
    
    
    //添加约束
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.view.mas_height);
    }];
    
    //取消按钮
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(bottomView.mas_left).offset(16);
        make.right.mas_equalTo(bottomView.mas_right).offset(-16);
        make.bottom.mas_equalTo(bottomView.mas_bottom).offset(-5);
    }];
    

}

#pragma mark - 按钮点击事件
//取消按钮
- (void)cancleBtnClick{
    
    [UIView animateWithDuration:animateDuration animations:^{
        self.bottomView.frame = CGRectMake(0, kUIScreenHeight, kUIScreenWidth, self.toolHeight);
        
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];

    }];
    
}
//遮盖按钮
- (void)coverBtnClick{
    [self cancleBtnClick];
}
//分享按钮点击
- (void)shareBtnClick:(UIButton *)button {
    if (button.tag == 10000) {//好友
        [self sendToScene:WXSceneSession];
    }else if(button.tag == 10001) {//朋友圈
        [self sendToScene:WXSceneTimeline];
    }else if(button.tag == 10002) {//收藏
        [self sendToScene:WXSceneFavorite];
    }
}
//使用时继承该类，重写改方法即可
- (void)sendToScene:(int) WXScene{
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]) {
        [self showMessage:@"未安装微信或者微信版本过低" delay:2];
    }
    
   
}

//修改图片的像素
- ( UIImage *)imageWithImageSimple:( UIImage *)image scaledToSize:( CGSize )newSize

{
    
    // Create a graphics image context
    
    UIGraphicsBeginImageContext (newSize);
    
    // Tell the old image to draw in this new context, with the desired
    
    // new size
    
    [image drawInRect : CGRectMake ( 0 , 0 ,newSize. width ,newSize. height )];
    
    // Get the new image from the context
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext ();
    
    // End the context
    
    UIGraphicsEndImageContext ();
    
    // Return the new image.
    
    return newImage;
    
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
}

////如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
//-(void)onResp:(BaseResp *)resp{
//    
//    
//    
//}
//
////onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
//-(void)onReq:(BaseReq *)req{
//    
//    
//    
//}

@end
