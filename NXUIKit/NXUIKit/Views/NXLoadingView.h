//
//  NXLoadingView.h
//  Schedule Pro
//
//  Created by Joe Sferrazza on 4/14/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

__deprecated
@interface NXLoadingView : UIView
+ (instancetype)createInView:(UIView *)superview title:(NSString *)title disableInteraction:(BOOL)superviewDisabled DEPRECATED_ATTRIBUTE DEPRECATED_MSG_ATTRIBUTE("Use NXIndicatorView's +showActivityIndicatorInView:title:disableInteraction: instead.");
- (void)hide;
- (void)hideWithCompletion:(void (^)())completion;
@end
