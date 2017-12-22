//
//  SegmentTapView.m
//  SegmentTapView

#import "SegmentTapView.h"
#define lineMargin  0
#define lineHeight  5

@interface SegmentTapView ()
@property (nonatomic, strong)NSMutableArray *buttonsArray;
@property (nonatomic, strong)UIImageView *lineImageView;
@end
@implementation SegmentTapView

-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArray withFont:(CGFloat)font {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        _buttonsArray = [[NSMutableArray alloc] init];
        _dataArray = dataArray;
        _titleFont = font;
        
        //默认
        self.textNomalColor    = [UIColor blackColor];
        self.textSelectedColor = [UIColor redColor];
        self.lineColor = [UIColor redColor];
        
        [self addSubSegmentView];
    }
    return self;
}

-(void)addSubSegmentView
{
    float width = self.frame.size.width / _dataArray.count;
    
    for (int i = 0 ; i < _dataArray.count ; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 0, width, self.frame.size.height)];
        button.tag = i+1;
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:[_dataArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:self.textNomalColor    forState:UIControlStateNormal];
        [button setTitleColor:self.textSelectedColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:_titleFont];
        
        [button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        //默认第一个选中
        if (i == 0) {
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
        
        [self.buttonsArray addObject:button];
        [self addSubview:button];
        
//        CGFloat margin = 40 * 0.15;
//        if (i != _dataArray.count && i != 0) {
//            UILabel *line = [[UILabel alloc ] initWithFrame:CGRectMake(i * width , margin, 0.45, 40 - 2 *margin)];
//            line.backgroundColor = [UIColor blackColor];
//            line.alpha = 0.4;
//            [self bringSubviewToFront:line];
//            [self addSubview:line];
//        }
    }
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake( width * lineMargin / 2, self.frame.size.height- lineHeight, width * (1 - lineMargin), lineHeight)];
    self.lineImageView.backgroundColor = _lineColor;
    [self addSubview:self.lineImageView];
    
    //分隔线
    UILabel *line = [[UILabel alloc ] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.561  green:0.765  blue:0.129 alpha:1];
    line.alpha = 1;
    [self bringSubviewToFront:line];
    [self addSubview:line];

}

-(void)tapAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    [UIView animateWithDuration:0.2 animations:^{
       self.lineImageView.frame = CGRectMake(button.frame.origin.x + button.frame.size.width * lineMargin / 2, self.frame.size.height - lineHeight, button.frame.size.width * (1 - lineMargin), lineHeight);
    }];
    for (UIButton *subButton in self.buttonsArray) {
        if (button == subButton) {
            subButton.selected = YES;
        }
        else{
            subButton.selected = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(selectedIndex:)]) {
        [self.delegate selectedIndex:button.tag -1];
    }
}
-(void)selectIndex:(NSInteger)index
{
    for (UIButton *subButton in self.buttonsArray) {
        if (index != subButton.tag) {
            subButton.selected = NO;
        }
        else{
            subButton.selected = YES;
            [UIView animateWithDuration:0.2 animations:^{
                self.lineImageView.frame = CGRectMake(subButton.frame.origin.x + subButton.frame.size.width * lineMargin / 2 , self.frame.size.height - lineHeight, subButton.frame.size.width * (1 - lineMargin), lineHeight);
            }];
        }
    }
}
#pragma mark -- set
-(void)setLineColor:(UIColor *)lineColor{
    if (_lineColor != lineColor) {
        self.lineImageView.backgroundColor = lineColor;
        _lineColor = lineColor;
    }
}
-(void)setTextNomalColor:(UIColor *)textNomalColor{
    if (_textNomalColor != textNomalColor) {
        for (UIButton *subButton in self.buttonsArray){
            [subButton setTitleColor:textNomalColor forState:UIControlStateNormal];
        }
        _textNomalColor = textNomalColor;
    }
}
-(void)setTextSelectedColor:(UIColor *)textSelectedColor{
    if (_textSelectedColor != textSelectedColor) {
        for (UIButton *subButton in self.buttonsArray){
            [subButton setTitleColor:textSelectedColor forState:UIControlStateSelected];
        }
        _textSelectedColor = textSelectedColor;
    }
}
-(void)setTitleFont:(CGFloat)titleFont{
    if (_titleFont != titleFont) {
        for (UIButton *subButton in self.buttonsArray){
            subButton.titleLabel.font = [UIFont systemFontOfSize:titleFont] ;
        }
        _titleFont = titleFont;
    }
}
@end
