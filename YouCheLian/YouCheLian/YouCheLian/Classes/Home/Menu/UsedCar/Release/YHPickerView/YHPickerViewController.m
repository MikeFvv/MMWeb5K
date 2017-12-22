//
//  YHPickerViewController.m
//  地区选择器
//
//  Created by Mike on 16/3/10.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "YHPickerViewController.h"
#import "CityOneModel.h"
#import "CityTWOModel.h"
#import "CityThreeModel.h"

#define  kCityViewHeight (kUIScreenHeight * 0.4)

@interface YHPickerViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIView *cityView;

@property (nonatomic, strong) UIPickerView *pickerView;


@end

@implementation YHPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化视图
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self initView];
    

    
    [self showCityView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化视图
- (void)initView{
    
    UIView *cityView = [[UIView alloc] init];
    cityView.frame = CGRectMake(0, kUIScreenHeight, kUIScreenWidth, kCityViewHeight);
    [self.view addSubview:cityView];
    self.cityView = cityView;
    
    //工具条
    UIView *toolView = [[UIView alloc] init];
    toolView.backgroundColor = [UIColor colorWithRed:0.145  green:0.706  blue:0.345 alpha:1];
    [cityView addSubview:toolView];
    
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cityView.mas_top);
        make.left.mas_equalTo(cityView.mas_left);
        make.right.mas_equalTo(cityView.mas_right);
        make.height.mas_equalTo(44);
        
    }];
    //分隔线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.3;
    [toolView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(toolView.mas_left);
        make.right.mas_equalTo(toolView.mas_right);
        make.bottom.mas_equalTo(toolView.mas_bottom);
        
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor lightGrayColor];
    line1.alpha = 0.3;
    [toolView addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(toolView.mas_left);
        make.right.mas_equalTo(toolView.mas_right);
        make.top.mas_equalTo(toolView.mas_top);
        
    }];
    
    
    //确定按钮
    UIButton * sureBtn = [[UIButton alloc] init];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(toolView.mas_top);
        make.bottom.mas_equalTo(toolView.mas_bottom);
        make.width.mas_equalTo(44);
        make.right.mas_equalTo(toolView.mas_right).offset(-10);
    }];
    
    //取消按钮
    UIButton * cancleBtn = [[UIButton alloc] init];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:cancleBtn];
    
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(toolView.mas_top);
        make.bottom.mas_equalTo(toolView.mas_bottom);
        make.width.mas_equalTo(44);
        make.left.mas_equalTo(toolView.mas_left).offset(10);
    }];
    
    //选择器
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [cityView addSubview:pickerView];
    _pickerView = pickerView;
    
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(cityView.mas_bottom);
        make.left.mas_equalTo(cityView.mas_left);
        make.right.mas_equalTo(cityView.mas_right);
        make.top.mas_equalTo(toolView.mas_bottom);
    }];
    
    
    
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
}

- (void)showCityView {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.cityView.frame = CGRectMake(0, kUIScreenHeight - kCityViewHeight, kUIScreenWidth, kCityViewHeight);
        
    } completion:^(BOOL finished) {
        
        UIButton *coverBtn = [[UIButton alloc] init];
        coverBtn.backgroundColor = [UIColor clearColor];
        [coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:coverBtn];
        
        [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top);
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(self.cityView.mas_top);
        }];
        
    }];
}

#pragma mark - 按钮点击事件

- (void)coverBtnClick {
    [UIView animateWithDuration:0.5 animations:^{
        
        self.cityView.frame = CGRectMake(0, kUIScreenHeight, kUIScreenWidth, kCityViewHeight);
        
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        //调用代理
        if ([self.delegate respondsToSelector:@selector(pickerViewControllerDisappear)]) {
            [self.delegate pickerViewControllerDisappear];
        }
        
    }];
    
    
}

- (void)sureBtnClick {
    NSInteger row1 = [self.pickerView selectedRowInComponent:0];
    CityOneModel *model1 =  self.dataArray[row1];
    
    NSInteger row2 = [self.pickerView selectedRowInComponent:1];
    CityTwoModel *model2 =  model1.citylist[row2];
    
    NSInteger row3 = [self.pickerView selectedRowInComponent:2];
    CityThreeModel *model3 =  model2.arealist[row3];
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@",model1.provinceName,model2.cityName,model3.areaName];
    
    
    if ([self.delegate respondsToSelector:@selector(pickerViewControllerDidClickSureBtnWithRow1:andRow2:andRow3:)]) {
        
        [self.delegate pickerViewControllerDidClickSureBtnWithRow1:row1 andRow2:row2 andRow3:row3];
        
    }
    
    [self cancleBtnClick];
    
    YHLog( @"%@",str);
    
}

- (void)cancleBtnClick {
    
    [self coverBtnClick];
    
}



#pragma mark - UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        
        return self.dataArray.count;
        
    }if (component == 1) {
        
        CityOneModel *model = self.dataArray[[pickerView selectedRowInComponent:0]];
        return model.citylist.count;
        
    }if (component == 2) {
        
        CityOneModel *model1 = self.dataArray[[pickerView selectedRowInComponent:0]];
        CityTwoModel *model2 = model1.citylist[[pickerView selectedRowInComponent:1]];
        return model2.arealist.count;
    }
    
    return 10;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        
        CityOneModel *model = self.dataArray[row];
        return model.provinceName;
        
    }if (component == 1) {
        
        CityOneModel *model1 = self.dataArray[[pickerView selectedRowInComponent:0]];
        CityTwoModel *model2 = nil;
        //防止数组越界错误
        if (row < model1.citylist.count) {
            model2 = model1.citylist[row];
        }
        return model2.cityName;
        
    }if (component == 2) {
        CityOneModel *model1 = self.dataArray[[pickerView selectedRowInComponent:0]];
        CityTwoModel *model2 = nil;
        //防止数组越界错误
        if ([pickerView selectedRowInComponent:1] < model1.citylist.count) {
            model2 =  model1.citylist[[pickerView selectedRowInComponent:1]];
        }
        CityThreeModel *model3 = nil;
        //防止数组越界错误
        if (row < model2.arealist.count) {
            model3 = model2.arealist[row];
        }
        return model3.areaName;
    }
    return @"渣渣";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [pickerView reloadAllComponents];
    
    if(component == 0 ){
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else if (component == 1) {
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    
    
}
@end
