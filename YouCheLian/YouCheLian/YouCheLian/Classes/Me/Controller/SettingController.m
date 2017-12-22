//
//  SettingController.m
//  YouCheLian
//
//  Created by Apple on 15/11/12.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "SettingController.h"
#import "GetPasswordController.h"
#import "ChangeBoundPhoneController.h"
#import "GetPasswordController.h"
#import "ChangeBoundPhoneController.h"
#import "ReceivingAddressController.h"
#import "ChangePasswordController.h"
#import <SDImageCache.h>



@interface SettingController() {
    MBProgressHUD *HUD;
}

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kViewControllerColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 第一组
    //    SettingController *setVC = [strory instantiateViewControllerWithIdentifier:@"SettingController"];
    SettingItem *item01 = [SettingItemArrow itemWithTitle:@"更改密码" icon:@"" destVc:[ChangePasswordController class]];
    SettingItemArrow *item02 = [SettingItemArrow itemWithTitle:@"更换绑定手机号" icon:@"" destVc:[ChangeBoundPhoneController class]];
    //    SettingItemArrow *item03 = [SettingItemArrow itemWithTitle:@"收货地址" icon:@"" destVc:[ReceivingAddressController class]];
    
//    SettingItemArrow *clearCache = [SettingItemArrow itemWithTitle:@"清空缓存"];
    SettingItemArrow *clearCache = [SettingItemArrow itemWithTitle:@"清空缓存" icon:@""];
   
    
    __weak typeof(clearCache) weakClearCache = clearCache;
    __weak typeof(self) weakSelf  =self;
    
    // way 2
    long long fileSize = [[SDImageCache sharedImageCache] getSize];
    
    YHLog(@"------%lld --------%lld",(long long)[[SDImageCache sharedImageCache] getSize], (long long)fileSize);
    //
    //
    //    //way 1
    clearCache.subTitle = [NSString stringWithFormat:@"%.2fM",[[SDImageCache sharedImageCache] getSize]/1024/1024.];
    //
    //
    clearCache.operationBlock = ^{
        //清除缓存
        
        [weakSelf showHudInView:self.view hint:@"正在清除..."];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            weakClearCache.subTitle  = [NSString stringWithFormat:@"%.2fM",[[SDImageCache sharedImageCache] getSize]/1024/1024.];
            [weakSelf hideHud];
            // 刷新表格
            [weakSelf.tableView reloadData];
            
            // 赶紧清除所有的内存缓存
            [[SDImageCache sharedImageCache] clearMemory];
            //
            [[SDImageCache sharedImageCache] clearDisk];
            
            [weakSelf showHint:@"清除完毕"];
        }];
        
        
    };
    
    //    SettingItemSwitch *item05 = [SettingItemSwitch itemWithTitle:@"推送消息"];
    //    item05.operationBlock = ^{
    //        YHLog(@"打开关闭推送");
    //    };
    
    SettingGroup *group1 = [SettingGroup groupWithItems:@[item01,item02,clearCache]];
    
    // 把组模型添加到数组中
    [self.groups addObject:group1];
}



//清理缓存
-(void) clearCache
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess)
                                              withObject:nil waitUntilDone:YES];});
}

-(void)clearCacheSuccess
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"缓存清理成功！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.indicatorStyle =UIScrollViewIndicatorStyleDefault;
    
    // #warning 在viewDidLoad中调用下列方法则不管用
    //分割线对齐屏幕边缘 方法缺一不可
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
