//
//  ShopIntroducesController.m
//  YouCheLian
//
//  Created by Mike on 15/12/16.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "ShopIntroducesController.h"

@interface ShopIntroducesController ()<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;

@end

@implementation ShopIntroducesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 64, kUIScreenWidth, kUIScreenHeight-64);  // ???
    
    self.title = @"商家介绍";

    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}


- (void)viewWillAppear:(BOOL)animated {
    // 显示隐藏导航栏
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.086  green:0.706  blue:0.325 alpha:1];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
//       NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    
//    self.navigationController.navigationBarHidden = NO;
}


//-(void)setNav {
//    // 设置title的字体颜色
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSFontAttributeName:kNavTitleFont18,
//       NSForegroundColorAttributeName:kFontColor}];
//    
//    // Nav 返回
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = kNav_Back_CGRectMake;
//    //    // 返回按钮内容左靠
//    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    
//    // 让返回按钮内容继续向左边偏移10
//    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
//    
//    [backBtn setImage:[UIImage imageNamed:@"bg_return_button"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(onBackBtn:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//}
//
//-(void)onBackBtn:(UIButton *)sender {
//    // 将栈顶的控制器移除
//    [self.navigationController popViewControllerAnimated:YES];
//}


- (void)initView {
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight-64)];
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;
    self.webView.hidden = YES;
    [self.view addSubview:self.webView];
    
    //    NSLog(@"%@",self.contentStr);
    //    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    //    [self.webView loadHTMLString:self.contentStr baseURL:baseURL];
    
    
    
    if (![self.contentStr isEqualToString:@""]) {
        //        label.text = [NSString stringWithFormat:@"    %@",self.contentStr];
        NSLog(@"%@",self.contentStr);
        self.webView.hidden = NO;
        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        [self.webView loadHTMLString:self.contentStr baseURL:baseURL];
        
    }else{
        UILabel *label = [[UILabel alloc] init];
        label.text = @"    商家太懒了，还没有添加介绍";
        label.numberOfLines = 0; // 自动换行
        label.textAlignment = NSTextAlignmentCenter;
        //    label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textColor = [UIColor lightGrayColor];
        label.font = YHFont(16, NO);;
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).with.offset(84);
            make.left.mas_equalTo(self.view.mas_left).with.offset(20);
            make.right.mas_equalTo(self.view.mas_right).with.offset(-20);
        }];
        
    }
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //设置webView的字体大小
    NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@%%'", @(250)]; //大小为1.25倍
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
    
   
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
