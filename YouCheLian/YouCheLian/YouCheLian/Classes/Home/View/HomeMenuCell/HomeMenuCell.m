//
//  HomeMenuCell.m
//  YouCheLian
//
//  Created by Mike on 15/11/10.
//  Copyright (c) Mike. All rights reserved.
//
#import "HomeMenuCell.h"
#import "MenuBtnView.h"

@interface HomeMenuCell ()<UIScrollViewDelegate>
@property (nonatomic , strong)UIView *firstBgView;
@property (nonatomic , strong)UIView *secondBgView;
@property (nonatomic, strong)UIPageControl *pageControl;
@end

@implementation HomeMenuCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableViewNo:(UITableView *)tableView menuArray:(NSArray *)menuArray
{
    static NSString *menuID = @"menu";
    
    HomeMenuCell *cell;
    if (tableView != nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:menuID];
        cell.frame = CGRectMake(0, 0, kUIScreenWidth, 160);
    }
    
    if (cell == nil) {
        cell = [[HomeMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:menuID menuArray:menuArray];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView menuArray:(NSArray *)menuArray;
{
    static NSString *menuID = @"menu";
    HomeMenuCell *cell;
    if(tableView != nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:menuID];
    }
    
    if (cell == nil) {
        cell = [[HomeMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:menuID menuArray:menuArray];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSArray *)menuArray{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _firstBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 100)];
        // 这是第2页的视图
//        _secondBgView = [[UIView alloc]initWithFrame:CGRectMake(kUIScreenWidth, 0, kUIScreenWidth, 160)];
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 100)];
        scrollView.delegate = self;
        //设置scrollView的滚动大小
        scrollView.contentSize = CGSizeMake(1*kUIScreenWidth, 100);
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        _firstBgView.backgroundColor = [UIColor colorWithRed:0.922  green:0.925  blue:0.929 alpha:1];
        
        [scrollView addSubview:_firstBgView];
//        [scrollView addSubview:_secondBgView];
        [self addSubview:scrollView];
        
      NSInteger count =  menuArray.count;
        //创建8个
        for (int i = 0; i < count; i++) {
            if (i < 3) {  // 这是第1页第1排
                CGRect frame = CGRectMake(i*kUIScreenWidth/3, 0, kUIScreenWidth/3, 80);
                NSString *title = [menuArray[i] objectForKey:@"title"];
                NSString *imageStr = [menuArray[i] objectForKey:@"image"];
                MenuBtnView *btnView = [[MenuBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag = 10+i;
                [_firstBgView addSubview:btnView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
                
            }else if(i < 6){   // 这是第1页第2排
                CGRect frame = CGRectMake((i-3)*kUIScreenWidth/3, 80, kUIScreenWidth/3, 80);
                NSString *title = [menuArray[i] objectForKey:@"title"];
                NSString *imageStr = [menuArray[i] objectForKey:@"image"];
                MenuBtnView *btnView = [[MenuBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag = 10+i;
                [_firstBgView addSubview:btnView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
                
            }else if(i < 12){  // 这是第2页第1排
                CGRect frame = CGRectMake((i-8)*kUIScreenWidth/4, 0, kUIScreenWidth/4, 80);
                NSString *title = [menuArray[i] objectForKey:@"title"];
                NSString *imageStr = [menuArray[i] objectForKey:@"image"];
                MenuBtnView *btnView = [[MenuBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag = 10+i;
                [_secondBgView addSubview:btnView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
            }else{  // 这是第2页第2排
                CGRect frame = CGRectMake((i-12)*kUIScreenWidth/4, 80, kUIScreenWidth/4, 80);
                NSString *title = [menuArray[i] objectForKey:@"title"];
                NSString *imageStr = [menuArray[i] objectForKey:@"image"];
                MenuBtnView *btnView = [[MenuBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag = 10+i;
                [_secondBgView addSubview:btnView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
            }
        }
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(kUIScreenWidth/2-20, 160, 0, 20)];
        _pageControl.currentPage = 0;
        // 设置下面分页 小圆圈个数
        _pageControl.numberOfPages = 0;
        // 设置小圆圈选中的颜色
        _pageControl.currentPageIndicatorTintColor = navigationBarColor;
        // 设置小圆圈没选择的颜色
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:_pageControl];

    }
    return  self;
}
 
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW =  scrollView.frame.size.width;
    //算出水平移的距离
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    _pageControl.currentPage = page;
}

//在这个地方搞一个代理通知控制器哪个按钮被点了 作出应以的处理
-(void)OnTapBtnView:(UITapGestureRecognizer*)sender{
//    YHLog(@"%ld", (long)sender.view.tag);
    if ([self.delegate respondsToSelector:@selector(homeMenuCellClick:)]) {
        [self.delegate homeMenuCellClick:(NSInteger)sender.view.tag];
    }
}

@end
