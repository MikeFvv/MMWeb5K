//
//  MeSystemMessageCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/23.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "MeSystemMessageCell.h"

@interface MeSystemMessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *unreadIcon;

@end

@implementation MeSystemMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(MeSystemMessageModel *)model {
    _model = model;
    
    
    //过滤html标签
    NSString *contentStr = [self flattenHTML:model.content];
    
    self.contentLabel.text = contentStr;
    
    self.titleLabel.text = model.title;
    if ([model.isRead isEqualToString:@"0"]) {
        
        self.unreadIcon.hidden = NO;
        
    }else{
        
        self.unreadIcon.hidden = YES;
        
    }
    
}

- (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    } // while //
    
    YHLog(@"-----===%@",html);
    return html;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
