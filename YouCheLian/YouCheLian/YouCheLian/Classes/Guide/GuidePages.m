//
//  GuidePages.m
//  WheelTime
//
//  Created by Mike on 16/1/18.
//  Copyright © 2016年 微微. All rights reserved.
//

#import "GuidePages.h"

#define kScrollbottomHeight kUIScreenHeight * 0.080

@interface GuidePages () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation GuidePages

// init
- (instancetype)init
{
    return [self initWithImageDatas:nil completion:nil];
}

// init with imageDatas and completion
- (instancetype)initWithImageDatas:(NSArray *)imageDatas completion:(void (^)(void))buttonAction
{
    self = [super init];
    if (self)
    {
        [self initView];
        //因为使用了懒加载，_imageDatas = imageDatas不会调用initContentView
        [self setImageDatas:imageDatas];
        _buttonAction = buttonAction;
    }
    return self;
}

//懒加载，并初始化内容
- (void)setImageDatas:(NSArray *)imageDatas
{
    _imageDatas = imageDatas;
    [self initContentView];
}

//基础视图初始化
- (void)initView
{
    // init view
    self.frame = CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight);
    
    // init scrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.frame = CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    // init pageControl
    _pageControl =
    [[UIPageControl alloc] initWithFrame:CGRectMake(0, kUIScreenHeight - kScrollbottomHeight, kUIScreenWidth, 10)];
    _pageControl.currentPage = 0;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.757  green:0.761  blue:0.765 alpha:1];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.561  green:0.765  blue:0.125 alpha:1];
    [self addSubview:_pageControl];
    
    // init button
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
}

//指定数据后，初始化显示内容
- (void)initContentView
{
    if (_imageDatas.count)
    {
        _pageControl.numberOfPages = _imageDatas.count;
        _scrollView.contentSize = CGSizeMake(kUIScreenWidth * _imageDatas.count, kUIScreenHeight);
        for (int i = 0; i < _imageDatas.count; i++)
        {
            NSString *imageName = _imageDatas[i];
            UIImageView *imgView =
            [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            imgView.frame = CGRectMake(kUIScreenWidth * i, 0, kUIScreenWidth, kUIScreenHeight);
            [self.scrollView addSubview:imgView];
            
            if (i == _imageDatas.count - 1)
            {
                
                _actionButton.layer.cornerRadius = 46/2;
                _actionButton.layer.masksToBounds = YES;
                [_actionButton setTitle:@"立即体验" forState:UIControlStateNormal];
                _actionButton.tintColor = [UIColor whiteColor];
                _actionButton.backgroundColor = [UIColor colorWithRed:0.561  green:0.765  blue:0.125 alpha:1];
                [_actionButton addTarget:self
                                  action:@selector(enterButtonClick)
                        forControlEvents:UIControlEventTouchUpInside];
                [imgView addSubview:_actionButton];
                //设置可以响应交互，UIImageView的默认值为NO
                imgView.userInteractionEnabled = YES;
                
                
                [_actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(imgView.mas_centerX);
                    make.bottom.mas_equalTo(imgView.mas_bottom).with.offset(-kScrollbottomHeight - 10);
                    make.size.mas_equalTo(CGSizeMake(140, 46));
                }];
            }
        }
    }
}

#pragma mark - 立即体验Action
- (void)enterButtonClick
{
    if (_buttonAction)
    {
        _buttonAction();
    }
    
    // 发送通知 开启定位
//    [[NSNotificationCenter defaultCenter]postNotificationName:OpeningPositioning object:nil];
}


#pragma mark - UIScrollView delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    _pageControl.currentPage = (_scrollView.contentOffset.x + SCREEN_WIDTH / 2) / SCREEN_WIDTH;
//}

//在结束滚动时设置页面，比滚动中改变页面性能更好，因为滚动一次只调用一次
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    _pageControl.currentPage = (_scrollView.contentOffset.x + kUIScreenWidth / 2) / kUIScreenWidth;
    // 最后一页要隐藏 分页控件
    if (_scrollView.contentOffset.x == kUIScreenWidth*(_imageDatas.count-1)) {
        _pageControl.hidden = YES;
    } else {
        _pageControl.hidden = NO;
    }
}

@end




