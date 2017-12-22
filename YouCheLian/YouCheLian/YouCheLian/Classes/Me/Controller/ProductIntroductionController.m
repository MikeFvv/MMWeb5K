//
//  ProductIntroductionController.m
//  YouCheLian
//
//  Created by Mike on 15/11/25.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "ProductIntroductionController.h"

@interface ProductIntroductionController ()

@property (strong, nonatomic) UIImageView *bgView;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation ProductIntroductionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.title = @"产品介绍";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight*0.30)];
    _bgView.image = [UIImage imageNamed:@"me_product_bg"];
    [self.view addSubview:_bgView];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.text = @"      优车联是深圳友浩车联网股份有限公司（证券简称：友浩车联 证券代码：836085）旗下品牌之一。优车联YoLink致力于为每一个车主打造安全、优惠、时尚的智能车联生活方式，传递“因驾驶而快乐，因梦想而幸福”的品牌价值主张，释放人类对车联网生活方式的梦想和追求。\n      用智能车联点缀用车生活的精彩，提升生活品质。秉承安全、智能、时尚的品牌个性，为当代爱车人士提供别具匠心的智能车联产品与服务，让人类通过安全智能的驾驶方式，领悟和享受更高层次的生命境界。";
    _contentLabel.font = YHFont(14, NO);;
    _contentLabel.textColor = kGlobalFontColor;
    _contentLabel.numberOfLines = 0;
    [self.view addSubview:_contentLabel];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgView.mas_bottom).with.offset(20);
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-20);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
