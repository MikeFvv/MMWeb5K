//
//  FoundShareViewController.m
//  YouCheLian
//
//  Created by Mike on 16/3/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FoundShareViewController.h"

@interface FoundShareViewController ()

@end

@implementation FoundShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendToScene:(int) WXScene{
    
    
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]) {
        [self showMessage:@"未安装微信或者微信版本过低" delay:2];
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.titleStr;//标题
    message.description = self.descStr;//描述
    [message setThumbImage:nil];//图片
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    
    YHLog(@"%@",self.path);
    NSString *urlStr = [self.path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    webpageObject.webpageUrl = urlStr;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXScene;
    
    [WXApi sendReq:req];
}

@end
