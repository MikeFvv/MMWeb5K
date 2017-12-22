//
//  CarJointShareController.m
//  YouCheLian
//
//  Created by Mike on 16/3/29.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "CarJointShareController.h"

@interface CarJointShareController ()

@end

@implementation CarJointShareController

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

        [self showMessage:@"未安装微信或者微信版本过低" delay:1.5];
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"智能车联";//标题
    message.description = @"专属你我的车联生活馆";//描述
    UIImage *sinpImage = [UIImage imageNamed:@"common_banner"];
    
    UIImage *image = [self imageWithImageSimple:sinpImage scaledToSize:CGSizeMake(sinpImage.size.width*0.5 , sinpImage.size.height*0.5)];
    [message setThumbImage:image];//图片
    
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


@end
