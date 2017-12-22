//
//  ReleaseCollectionViewCell.m
//  YouCheLian
//
//  Created by Mike on 16/3/8.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ReleaseCollectionViewCell.h"


@interface ReleaseCollectionViewCell ()



@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation ReleaseCollectionViewCell

- (IBAction)deleteBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(releaseCollectionViewCellDidClickDeleteBtn:)]) {
        
        [self.delegate releaseCollectionViewCellDidClickDeleteBtn:self];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setImage:(UIImage *)image{
    _image = image;
    
    self.iconView.image = image;
}

- (void)setDeleteBtnHidden:(BOOL)deleteBtnHidden{
    _deleteBtnHidden = deleteBtnHidden;
    
    self.deleteBtn.hidden = deleteBtnHidden;
}

@end
