//
//  AddDeviceController.h
//  YouCheLian
//
//  Created by Mike on 15/11/11.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^QRUrlBlock)(NSString *url);

// 添加设备使用二维码扫描
@interface AddDeviceController : UIViewController

@property (nonatomic, copy) QRUrlBlock qrUrlBlock;

@end
