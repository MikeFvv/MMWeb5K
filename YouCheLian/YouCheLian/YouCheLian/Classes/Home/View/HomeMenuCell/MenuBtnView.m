//
//  MenuBtnView.m
//  YouCheLian
//
//  Created by Mike on 15/11/10.
//  Copyright (c) Mike. All rights reserved.
//

#import "MenuBtnView.h"

@implementation MenuBtnView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame title:(NSString *)title imageStr:(NSString *)imageStr{
    self = [super initWithFrame:frame];
    if (self) {
        //
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-22, 15, 50, 50)];
        YHLog(@"====%f",frame.size.width/2-22);
        imageView.image = [UIImage imageNamed:imageStr];
        [self addSubview:imageView];
        
        //
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(3, 15+50, frame.size.width, 20)];
        titleLable.text = title;
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleLable];
    }
    return self;
}
@end
