//
//  ShopDiscountController.m
//  YouCheLian
//
//  Created by Mike on 15/12/16.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "ShopDiscountController.h"
#import "ShopDiscountCell.h"
#import "VoucherModels.h"
#import "VoucherModel.h"
#import <MJExtension.h>

@interface ShopDiscountController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) VoucherModels *voucherModels;
@property (nonatomic,strong) VoucherModel *voucherModel;
@property (nonatomic,strong) NSArray *voArray;
@end

@implementation ShopDiscountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺优惠活动";
    [self.view addSubview:self.tableView];
}


#pragma mark - 初始化 tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kUIScreenWidth,kUIScreenHeight - kUINavHeight) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        // 隐藏分割线
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor whiteColor];
        //去掉下面没有数据呈现的cell
        self.tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}






/// 商家优惠  商家未领取代金券
- (void)GetVoucherData:(NSString *)shopId {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1031" forKey:@"rec_code"];
    
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; //注册手机（不能为空）
    [dictParam setValue:shopId forKey:@"rec_id"]; // 商家Id（不能为空）
    [dictParam setValue:@"2" forKey:@"rec_type"]; // 1=未领取的，2=未领取和已领取
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];

    
    YHLog(@"%@", [YHFunction dictionaryToJson:dictParam]);
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        
        YHLog(@"%@",result);
        
        if ([result[@"res_num"] isEqualToString:@"0"]) {  // 成功
            _voucherModels = [VoucherModels mj_objectWithKeyValues:result];
            self.voArray = _voucherModels.dataList;
            [self.tableView reloadData];
        }
        return YES;
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

// 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey";
    // 首先根据标示去缓存池取
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // 如果缓存池没有取到则重新创建并放到缓存池中
    if(cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    };
    
    if (self.voArray.count == 0) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = @"暂无相关数据..";
        cell.textLabel.font = YHFont(16, NO);;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.imageView.backgroundColor = [UIColor colorWithRed:0.071  green:0.310  blue:0.420 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        ShopDiscountCell *cell = [ShopDiscountCell cellWithTableView:tableView];
        cell.model = self.voArray[indexPath.row];
        
        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
