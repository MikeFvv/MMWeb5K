

#import "UIFont+YH.h"


#define kFontNameHeiti @"STHeitiSC-Medium"
#define kFontNameHelvetica @"Helvetica"
#define kFontNameHelveticaBold  @"Helvetica-Bold"
#define kFontNameLightHeiti @"STHeitiSC-Light"
#define kFontNameNeueLight  @"HelveticaNeue-Light"
#define kFontNameNeueBold   @"HelveticaNeue-Bold"

@implementation UIFont (YH)

+(instancetype) fontForHelveticaWithSize:(CGFloat) size bold:(BOOL) bold {
    if (bold) {
        return [UIFont fontWithName:kFontNameHelveticaBold size:size];
    } else {
        return [UIFont fontWithName:kFontNameHelvetica size:size];
    }
}
+(instancetype) fontForSTHeitiSCWithSize:(CGFloat) size bold:(BOOL) bold {
    if (bold) {
        return [UIFont fontWithName:kFontNameHeiti size:size];
    } else {
        return [UIFont fontWithName:kFontNameLightHeiti size:size];
    }
}

+(instancetype) fontForHelveticaNeueWithSize:(CGFloat) size bold:(BOOL) bold {
    if (bold) {
        return [UIFont fontWithName:kFontNameNeueBold size:size];
    } else {
        return [UIFont fontWithName:kFontNameNeueLight size:size];
    }
}

@end
