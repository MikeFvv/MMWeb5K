//
//  PlaceholderTextView.h
//  YouCheLian
//
//  Created by Mike on 15/11/26.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

@property (nonatomic, strong) UILabel * placeHolderLabel;

@property (nonatomic, copy) NSString * placeholder;

@property (nonatomic, strong) UIColor * placeholderColor;

- (void)textChanged:(NSNotification * )notification;

@end
