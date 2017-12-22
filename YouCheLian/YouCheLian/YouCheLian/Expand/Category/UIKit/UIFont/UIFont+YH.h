

#import <UIKit/UIKit.h>



/**设置字体大小（__size__  字体大小  ， __bold__  YES：粗体 NO：常规）*/
#define YHFont(__size__,__bold__)              (__bold__?[UIFont boldSystemFontOfSize:__size__]:[UIFont systemFontOfSize:__size__])

#define YHFontHelvetica(__size__,__bold__)     [UIFont fontForHelveticaWithSize:__size__ bold:__bold__]

#define YHFontSTHeitiSC(__size__,__bold__)     [UIFont fontForSTHeitiSCWithSize:__size__ bold:__bold__]

#define YHFontHelveticaNeue(__size__,__bold__) [UIFont fontForHelveticaNeueWithSize:__size__ bold:__bold__]


@interface UIFont (YH)

+(instancetype) fontForHelveticaWithSize:(CGFloat) size bold:(BOOL) bold;

+(instancetype) fontForSTHeitiSCWithSize:(CGFloat) size bold:(BOOL) bold;

+(instancetype) fontForHelveticaNeueWithSize:(CGFloat) size bold:(BOOL) bold;


@end
