//
//  BuyCarViewController.m
//  motoronline
//
//  Created by Mike on 16/1/26.
//  Copyright © 2016年 HuanFeng. All rights reserved.
//

#import "BuyCarViewController.h"
#import "CarColorListModel.h"
#import "DefaultWebController.h"
#import "LoginViewController.h"
#import "YHNavigationController.h"
#import "CarJointDetailsController.h"
#define animateDuration  0.3
//#define toolHeight 150
#define rowHeight 40

#define lowViewHeight (16 * 5 + 48 * 130/180 + 14)
#define topViewHeight (117 + 16 + 16)

@interface BuyCarViewController ()

@property (nonatomic, strong) UIView *conentView;
//conentview高度
@property (nonatomic, assign) CGFloat toolHeight;
//mideview高度
@property (nonatomic, assign) CGFloat midViewHeight;


@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UIView *lowView;
////购买数量
//@property (nonatomic, assign) int buyCount;
//购买输入框
@property (nonatomic, strong) UITextField *numTextField;
//活动价
@property (nonatomic, strong) UILabel *priceLabel;
//门店价或者定金
@property (nonatomic, strong) UILabel *marketPriceLabel;
//库存
@property (nonatomic, strong) UILabel *stockLabel;
//no是支付定金  yes是支付活动价
@property (nonatomic, assign) BOOL isBuyNow;
//门店价下划线
@property (nonatomic, strong) UIView *bottomline;

@end



@implementation BuyCarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //定金等于0时 为立即购买
    self.isBuyNow = [self.earnestMoney isEqualToString:@"0"];
    
    //当为商品类型时， 隐藏定金，设置为立即购买按钮
    if([self.type isEqualToString:@"0"]){
        self.isBuyNow = YES;
    }
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //初始化界面
    [self initView];

    //showButtomView
    [self showButtomView];
    
    //当为商品类型时， 隐藏定金，设置为立即购买按钮
    if([self.type isEqualToString:@"0"]){
        self.marketPriceLabel.hidden = YES;
        self.bottomline.hidden = YES;
    }

}


//初始化界面
- (void)initView{
    
    //遮盖按钮
    UIButton *coverBtn = [[UIButton alloc] init];
    [coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [coverBtn setBackgroundColor:[UIColor blackColor]];
    coverBtn.alpha = 0.3;
    [self.view addSubview:coverBtn];
    
    //底部视图
    UIView *conentView = [[UIView alloc] init];
    conentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:conentView];
    self.conentView = conentView;
    
    //topView
    [self setupTopView];
    //中间颜色视图
    [self setupMidView];
    //底部购买视图
    [self setupLowView];
    
    self.toolHeight = self.midViewHeight + topViewHeight + lowViewHeight;
    
    conentView.frame = CGRectMake(0,kUIScreenHeight, kUIScreenWidth, self.toolHeight);
    
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.view.mas_height);
    }];
}


#pragma mark - 创建视图
//头部视图
- (void)setupTopView{
    UIView *topView = [[UIView alloc] init];
    [self.conentView addSubview:topView];
    self.topView = topView;
    
    //iconView 预览图片
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView ww_setImageWithString:self.motoPhoto wihtImgName:@"buycar_icon"];
    
//    //设置图片拉伸
//    iconView.clipsToBounds = YES;
//    iconView.contentMode = UIViewContentModeScaleAspectFill;

    [topView addSubview:iconView];
    
    //取消按钮
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"buycar_close"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancleBtn];
    
    
    //取出模型
    CarColorListModel *colorModel1;
    if(self.dataModels.count == 0){
        
        colorModel1 = NULL;
    }else{
        //取出模型
        colorModel1 = self.dataModels[self.selectIndex];
        
    }

    //活动价label
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = [NSString stringWithFormat:@"¥ %@",self.price];
    priceLabel.font = [UIFont systemFontOfSize:20];
    priceLabel.textColor = [UIColor redColor];
    [topView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    //划线
    UIView *bottomline = [[UIView alloc] init];
    bottomline.backgroundColor = [UIColor blackColor];
    bottomline.hidden = YES;
    [topView addSubview:bottomline];
    self.bottomline = bottomline;
    
    
    //定金或门市价
    UILabel *marketPriceLabel = [[UILabel alloc] init];
    
    /// 定金 定金=0显示门市价，定金>0显示定金
//    if (self.isBuyNow) {
//        
//        marketPriceLabel.text = [NSString stringWithFormat:@"门市价: ¥%@",self.marketPrice ? self.marketPrice : @"- -"];
//        bottomline.hidden = NO;
//    }else{
    
        marketPriceLabel.text = [NSString stringWithFormat:@"定金: ¥%@",self.earnestMoney ? self.earnestMoney : @"- -"];
        marketPriceLabel.textColor = [UIColor redColor];
//    }
    
    marketPriceLabel.font = [UIFont systemFontOfSize:13];
    
    [topView addSubview:marketPriceLabel];
    self.marketPriceLabel = marketPriceLabel;
    
    
    
    //库存
    UILabel *stockLabel = [[UILabel alloc] init];
    stockLabel.text = [NSString stringWithFormat:@"库存: %@",colorModel1.stock ? colorModel1.stock : @"- -"];
    stockLabel.font = [UIFont systemFontOfSize:13];
    [topView addSubview:stockLabel];
    self.stockLabel = stockLabel;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:line];
    
    //约束
    
    //topView
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.conentView.mas_top);
        make.left.mas_equalTo(self.conentView.mas_left);
        make.right.mas_equalTo(self.conentView.mas_right);
        make.height.mas_equalTo(topViewHeight);
    }];
    //预览图
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_top).offset(16);
        make.left.mas_equalTo(topView.mas_left).offset(16);
        make.height.mas_equalTo(117);
        make.width.mas_equalTo(140);
    }];
    //取消按钮
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconView.mas_top);
        make.right.mas_equalTo(topView.mas_right).offset(-16);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(32);
    }];
    //活动价
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(stockLabel.mas_left);
        make.bottom.mas_equalTo(marketPriceLabel.mas_top).offset(-8);
    }];
    //门市价或者定金
    [marketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(stockLabel.mas_left);
        make.bottom.mas_equalTo(stockLabel.mas_top).offset(-8);
        
    }];
    //下划线
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(marketPriceLabel.mas_centerY);
        make.left.mas_equalTo(marketPriceLabel.mas_left).offset(-3);
        make.right.mas_equalTo(marketPriceLabel.mas_right).offset(3);
        make.height.mas_equalTo(1);
    }];
    //库存
    [stockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(iconView.mas_bottom).offset(-8);
        make.left.mas_equalTo(iconView.mas_right).offset(16);
        
    }];
    
    //分隔线
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(topView.mas_bottom);
        make.left.mas_equalTo(topView.mas_left);
        make.right.mas_equalTo(topView.mas_right);
        make.height.mas_equalTo(0.5);
    }];
}



//中间视图
- (void)setupMidView{
    
    UIView *midView = [[UIView alloc] init];
    [self.conentView addSubview:midView];
    self.midView = midView;
    
    //活动价label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"颜色";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [midView addSubview:titleLabel];
    
    //分隔线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [midView addSubview:line];
    
    //列数
    int totalCol = 5;
    //行数
    int totalRow = ((int)self.dataModels.count / totalCol) + 1;
    //    int totalRow = 10 / totalCol;
    //间距
    CGFloat margin = 8;
    //按钮的宽
    CGFloat btnWidth = (kUIScreenWidth - margin * 8) / totalCol;
    //按钮的高
    CGFloat btnHeight = btnWidth *  96 / 180;
    
    //midView的高度
    self.midViewHeight = 16 * 3 + btnHeight * totalRow + margin * (totalRow - 1) + 16;
    
    //约束
    //midView
    [midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.mas_equalTo(self.conentView.mas_left);
        make.right.mas_equalTo(self.conentView.mas_right);
        make.height.mas_equalTo(self.midViewHeight);
    }];
    //标题
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.midView.mas_top).offset(16);
        make.left.mas_equalTo(self.midView.mas_left).offset(16);
        
    }];
    
    //分隔线
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(midView.mas_bottom);
        make.left.mas_equalTo(midView.mas_left);
        make.right.mas_equalTo(midView.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    
    
    
    for (int i = 0; i < self.dataModels.count; i++) {
        
        int rowNum = i / totalCol;
        int colNum = i % totalCol;
        
        //取出模型
        CarColorListModel *colorModel = self.dataModels[i];
        //颜色按钮
        UIButton *colorBtn = [[UIButton alloc] init];
        colorBtn.layer.cornerRadius = 3;
        colorBtn.layer.borderWidth = 1;
        colorBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        colorBtn.tag = 100 + i;
        [colorBtn setTitle:colorModel.colName forState:UIControlStateNormal];
        [colorBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [colorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [colorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        //设置颜色
        if (i == self.selectIndex) {
            colorBtn.selected = YES;
            [colorBtn setBackgroundColor:[UIColor colorWithRed:0.145  green:0.706  blue:0.345 alpha:1]];
        }else{
            [colorBtn setBackgroundColor:[UIColor colorWithRed:0.914  green:0.969  blue:0.914 alpha:1]];
        }
        [colorBtn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [midView addSubview:colorBtn];
        
        //颜色按钮约束
        [colorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(16 + (margin + btnHeight) * rowNum);
            make.left.mas_equalTo(self.midView.mas_left).offset(16 + (margin + btnWidth) * colNum);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(btnHeight);
            
        }];
        
    }
}





//底部视图
- (void)setupLowView{
    
    UIView *lowView = [[UIView alloc] init];
    [self.conentView addSubview:lowView];
    self.lowView = lowView;
    
    //活动价label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"购买数量";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [lowView addSubview:titleLabel];
    
    //分隔线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [lowView addSubview:line];
    //减少按钮
    UIButton *reduceBtn =[[UIButton alloc] init];
    [reduceBtn setTitle:@"－" forState:UIControlStateNormal];
    [reduceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reduceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [reduceBtn.titleLabel setFont:[UIFont systemFontOfSize:24]];
    [reduceBtn addTarget:self action:@selector(reduceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [lowView addSubview:reduceBtn];
    
    //textField
    UITextField *numTextField = [[UITextField alloc] init];
    numTextField.text = [NSString stringWithFormat:@"%d",self.buyCount];
    numTextField.userInteractionEnabled = NO;
    numTextField.borderStyle = UITextBorderStyleRoundedRect;
    numTextField.keyboardType = UIKeyboardTypeNumberPad;
    numTextField.textAlignment = NSTextAlignmentCenter;
    numTextField.backgroundColor = [UIColor colorWithRed:0.910  green:0.965  blue:0.910 alpha:1];
    [lowView addSubview:numTextField];
    self.numTextField = numTextField;
    
    //增加按钮
    UIButton *addBtn =[[UIButton alloc] init];
    [addBtn setTitle:@"＋" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [addBtn.titleLabel setFont:[UIFont systemFontOfSize:24]];
    
    
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [lowView addSubview:addBtn];
    
    //加入购物车
    UIButton *addToShopCarBtn =[[UIButton alloc] init];
    [addToShopCarBtn setBackgroundImage:[UIImage imageNamed:@"buycar_addtoshopcar"] forState:UIControlStateNormal];
    [addToShopCarBtn setBackgroundImage:[UIImage imageNamed:@"buycar_addtoshopcar_press"] forState:UIControlStateHighlighted];
    [addToShopCarBtn addTarget:self action:@selector(addToShopCarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [lowView addSubview:addToShopCarBtn];
    
    //立即购买按钮
    UIButton *buyNowBtn =[[UIButton alloc] init];
    
    ///// 定金 定金=0显示立即购买，定金>0显示支付定金
    NSString *buyNowBtnIconName = nil;
    if (self.isBuyNow) {
        
        buyNowBtnIconName = @"buycar_buynow";
       
    }else{
        
        buyNowBtnIconName = @"buycar_earnestMoney";
        
    }
    [buyNowBtn setBackgroundImage:[UIImage imageNamed:buyNowBtnIconName] forState:UIControlStateNormal];
    [buyNowBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_press",buyNowBtnIconName]] forState:UIControlStateHighlighted];
    [buyNowBtn addTarget:self action:@selector(buyNowBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [lowView addSubview:buyNowBtn];
    
    //约束
    //lowView
    [lowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.midView.mas_bottom);
        make.left.mas_equalTo(self.conentView.mas_left);
        make.right.mas_equalTo(self.conentView.mas_right);
        make.height.mas_equalTo(lowViewHeight);
    }];
    //标题
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lowView.mas_top).offset(16);
        make.left.mas_equalTo(self.lowView.mas_left).offset(16);
        
    }];
    //分隔线
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(16);
        make.left.mas_equalTo(lowView.mas_left);
        make.right.mas_equalTo(lowView.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    
    //增加按钮
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lowView.mas_top);
        make.right.mas_equalTo(self.lowView.mas_right).offset(-8);
        make.bottom.mas_equalTo(line.mas_top);
        make.width.mas_equalTo(addBtn.mas_height).offset(-10);
        
    }];
    //textField按钮
    [numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lowView.mas_top).offset(16);
        make.bottom.mas_equalTo(line.mas_top).offset(-16);
        make.right.mas_equalTo(addBtn.mas_left);
        make.width.mas_equalTo(addBtn.mas_width);
        
    }];
    //减少按钮
    [reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lowView.mas_top);
        make.right.mas_equalTo(numTextField.mas_left);
        make.bottom.mas_equalTo(line.mas_top);
        make.width.mas_equalTo(addBtn.mas_width);
        
    }];
    //加入购物车按钮
    [addToShopCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_top).offset(16);
        make.left.mas_equalTo(self.lowView.mas_left).offset((kUIScreenWidth - 130 * 2) / 3);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(48 * 130/180);
        
    }];
    //立即购买按钮
    [buyNowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_top).offset(16);
        make.right.mas_equalTo(self.lowView.mas_right).offset(-(kUIScreenWidth - 130 * 2) / 3);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(48 * 130/180);
        
    }];
    
}

#pragma mark - 按钮点击事件
//立即购买或者支付定金
- (void)buyNowBtnClick{
   
    //判断是否登录
    if (![YHUserInfo shareInstance].uPhone) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.loginOrReg = YES;
        YHNavigationController *loginView = [[YHNavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:loginView animated:YES completion:nil];
        [self showMessage:LoginTipMessage delay:1];
        
    } else { //已经登录
        
        //取出模型
        CarColorListModel *colorModel1;
        if(self.dataModels.count == 0){
            
            colorModel1 = NULL;
        }else{
            //取出模型
            colorModel1 = self.dataModels[self.selectIndex];
            
        }
        
        //判断库存是否大于0
        if (colorModel1 && colorModel1.stock.intValue > 0 && self.price.floatValue > 0 && self.buyCount <= colorModel1.stock.intValue) {
            [self coverBtnClick];
            [self buyAction];
            
        }else{
            
            MBProgressHUD *hub = [[MBProgressHUD alloc] init];
            hub.labelText = @"库存不足";
            hub.mode = MBProgressHUDModeText;
            [hub show:YES];
            [[UIApplication sharedApplication].keyWindow addSubview:hub];
            [hub hide:YES afterDelay:1];
        }
    }
}

//跳转到购买页面
- (void)buyAction {
   
    CarColorListModel *colorModel1 = self.dataModels[self.selectIndex];
    
    
    NSString *acType = nil;
    if ([self.type isEqualToString:@"0"]) {
        acType = @"zncl";
    }else  {
        acType = @"new";
    }
    
    //pid--新车或者活动的商品ＩＤ，attrId－颜色属性ＩＤ,num- 购买数量,  type- 类型0商城 1 2
    NSString *urlStr = [NSString stringWithFormat:@"%@?ac=%@&pid=%@&type=%@&attrId=%@&num=%d",[[GetUrlString sharedManager] urlBuyWeb],acType,self.carId,self.type,[NSString stringWithFormat:@"%zd",colorModel1.colId],self.buyCount];
    
    DefaultWebController *mallVC = [[DefaultWebController alloc]init];
    mallVC.urlStr = [YHFunction getWebUrlWithUrl:urlStr];
    CarJointDetailsController *carVC = (CarJointDetailsController *)self.delegate;
    [carVC.navigationController pushViewController:mallVC animated:YES];
}

#pragma mark - 加入购物车
// 加入购物车
- (void)addToShopCarBtnClick{
    
    //判断是否登录
    if (![YHUserInfo shareInstance].isLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.loginOrReg = YES;
        YHNavigationController *loginView = [[YHNavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:loginView animated:YES completion:nil];
        [self showMessage:LoginTipMessage delay:1];
        
    }else{
        //取出模型
        CarColorListModel *colorModel1;
        if(self.dataModels.count == 0){
            
            colorModel1 = NULL;
        }else{
            //取出模型
            colorModel1 = self.dataModels[self.selectIndex];
            
        }
        
        if (colorModel1 && colorModel1.stock.intValue > 0 && self.buyCount <= colorModel1.stock.intValue ) {
            [self sendRequest];
            
        }else{
            
            MBProgressHUD *hub = [[MBProgressHUD alloc] init];
            hub.labelText = @"库存不足";
            hub.mode = MBProgressHUDModeText;
            [hub show:YES];
            [[UIApplication sharedApplication].keyWindow addSubview:hub];
            [hub hide:YES afterDelay:1];
        }
    }
}


- (void)sendRequest {
    // 创建一个空字典
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"1062" forKey:@"rec_code"];
    
    [dictParam setValue:self.type forKey:@"rec_type"]; //（0商品，1新车（推荐车型），2活动（品牌活动）
    [dictParam setValue:self.carId forKey:@"rec_id"]; // 商品或者新车ID
    //[YHUserInfo shareInstance].uPhone
    [dictParam setValue:[YHUserInfo shareInstance].uPhone forKey:@"rec_userPhone"]; // 手机号码
    
    CarColorListModel *colorModel = self.dataModels[self.selectIndex];
    [dictParam setValue:[NSString stringWithFormat:@"%zd",colorModel.colId] forKey:@"rec_attrid"]; // 属性ＩＤ(颜色)
    
    [dictParam setValue:[NSString stringWithFormat:@"%d",self.buyCount] forKey:@"rec_num"];//num 数量
    
    //  MD5 加密
    [dictParam setObject:[YHFunction md5StringFromDictionary:dictParam] forKey:@"sign"];

    YHLog(@"字符串===%@",[YHFunction dictionaryToJson:dictParam]);
    
    [[NetworkTools sharedTools] request:POST urlString:[[GetUrlString sharedManager] urlYoLinkWebHttp] parameters:dictParam finished:^BOOL(id result, NSError *error) {
        YHLog(@"%@",result);
        
        if ([result[@"res_num"] isEqualToString:@"0"]){
            
            [self cancleBtnClick];
            MBProgressHUD *hub = [[MBProgressHUD alloc] init];
            hub.labelText = @"加入购物车成功";
            hub.mode = MBProgressHUDModeText;
            [hub show:YES];
            [[UIApplication sharedApplication].keyWindow addSubview:hub];
            [hub hide:YES afterDelay:1];
            
        }else{
            
            MBProgressHUD *hub = [[MBProgressHUD alloc] init];
            hub.labelText = @"加入购物车失败";
            hub.mode = MBProgressHUDModeText;
            [hub show:YES];
            [[UIApplication sharedApplication].keyWindow addSubview:hub];
            [hub hide:YES afterDelay:1];
            
        }
        return YES;
    }];
}


//增加按钮
- (void)addBtnClick{
    
    //取出模型
    CarColorListModel *colorModel1;
    if(self.dataModels.count == 0){
        
        colorModel1 = NULL;
    }else{
        //取出模型
        colorModel1 = self.dataModels[self.selectIndex];
        
    }
    
    if ( self.buyCount < colorModel1.stock.intValue) {
        self.buyCount++;
        self.numTextField.text = [NSString stringWithFormat:@"%d",self.buyCount];
    }
    
}

//减少按钮
- (void)reduceBtnClick{
    if (self.buyCount > 1) {
        self.buyCount--;
        self.numTextField.text = [NSString stringWithFormat:@"%d",self.buyCount];
        
    }
}
//颜色按钮
- (void)colorBtnClick:(UIButton *)btn{
    
    for (int i = 0 ; i < self.dataModels.count; i++) {
        UIButton *colorBtn = (UIButton *)[self.midView viewWithTag:100 + i];
        [colorBtn setBackgroundColor:[UIColor colorWithRed:0.914  green:0.969  blue:0.914 alpha:1]];
        colorBtn.selected = NO;
    }
    btn.selected = YES;
    self.selectIndex = btn.tag - 100;
    [btn setBackgroundColor:[UIColor colorWithRed:0.145  green:0.706  blue:0.345 alpha:1]];
    
    //取出模型
    CarColorListModel *colorModel = self.dataModels[btn.tag - 100];
    //修改活动价
//    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",colorModel.price];
    //修改库存
    self.stockLabel.text = [NSString stringWithFormat:@"库存: %@",colorModel.stock.stringValue];
}


//取消按钮
- (void)cancleBtnClick{
    
    [UIView animateWithDuration:animateDuration animations:^{
        self.conentView.frame = CGRectMake(0, kUIScreenHeight, kUIScreenWidth, self.toolHeight);
        
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
    }];
    
    //调用代理
    if ([self.delegate respondsToSelector:@selector(buyCarViewController:exitWithSelectIndex:andBuyCount:)]) {
        
        [self.delegate buyCarViewController:self exitWithSelectIndex:self.selectIndex andBuyCount:self.buyCount];
    }
    
}

//遮盖按钮
- (void)coverBtnClick{
    [self cancleBtnClick];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
}

- (void)showButtomView{
    [UIView animateWithDuration:animateDuration animations:^{
        self.conentView.frame = CGRectMake(0, kUIScreenHeight - self.toolHeight, kUIScreenWidth, self.toolHeight);
        
    } completion:^(BOOL finished) {
        
    }];
}

@end
