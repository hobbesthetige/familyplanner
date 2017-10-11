//
//  UIFont+System.h
//  NXUIKit
//
//  Created by Joseph Sferrazza on 7/6/15.
//  Copyright © 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

//When iOS 9 is the minimum SDK, refactor code using these constants to remove the NX_, then delete these
extern const CGFloat NX_UIFontWeightUltraLight;
extern const CGFloat NX_UIFontWeightThin;
extern const CGFloat NX_UIFontWeightLight;
extern const CGFloat NX_UIFontWeightRegular;
extern const CGFloat NX_UIFontWeightMedium;
extern const CGFloat NX_UIFontWeightSemibold;
extern const CGFloat NX_UIFontWeightBold;
extern const CGFloat NX_UIFontWeightHeavy;
extern const CGFloat NX_UIFontWeightBlack;

@interface UIFont (System)
//When iOS 9 is the minimum SDK, refactor code calling this removing the nx_ and then delete this method
+ (UIFont *)nx_systemFontOfSize:(CGFloat)size weight:(CGFloat)weight;
@end
