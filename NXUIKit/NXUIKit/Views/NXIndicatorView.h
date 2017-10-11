//
//  NXIndicatorView.h
//  NXUIKit
//
//  Created by Joseph Sferrazza on 7/6/15.
//  Copyright © 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NXIndicatorViewStyle) {
    NXIndicatorViewStyleActivity,
    NXIndicatorViewStyleActivitySmall,
    NXIndicatorViewStylePercentage,
    NXIndicatorViewStylePercentageSmall,
    NXIndicatorViewStyleSpinning,
    NXIndicatorViewStyleSpinningSmall
};

@interface NXIndicatorView : UIView

@property (nonatomic, assign, readonly) NXIndicatorViewStyle style;

/** White by default. */
@property (nonatomic, strong, nullable) UIColor *contentColor;

/**
 Displays an activity indicator inside a square dark blurred UIVisualEffectView with the specified text.
 
 @param style Determines whether an activity indicator is shown or if a percentage is shown.
 @param superview The superview for this indicator.
 @param superviewDisabled Whether or not to disable user interaction in the superview while this indicator is displayed
 */
+ (nonnull instancetype)showIndicatorWithStyle:(NXIndicatorViewStyle)style superview:(nonnull UIView *)superview disableInteraction:(BOOL)superviewDisabled;

/**
 Displays an activity indicator inside a square dark blurred UIVisualEffectView with the specified text.
 
 @param style Determines whether an activity indicator is shown or if a percentage is shown.
 @param superview The superview for this indicator.
 @param title The text to display below the activity indicator.  If @p nil, the word @a Loading is displayed. Not yet implemented for NXIndicatorViewStylePercentage
 @param superviewDisabled Whether or not to disable user interaction in the superview while this indicator is displayed
 */
+ (nonnull instancetype)showIndicatorWithStyle:(NXIndicatorViewStyle)style superview:(nonnull UIView *)superview title:(nullable NSString *)title disableInteraction:(BOOL)superviewDisabled;
- (void)hide;
- (void)hideWithCompletion:(void (^ __nullable )())completion;

/**
 Updates the percentage shown in the indicator - this only applies when the current style is set to @p NXIndicatorViewStylePercentage
 
 @param percentage The new percentage to display.  Should be a value between 0.0 & 1.0.
 */
- (void)updatePercentage:(CGFloat)percentage;
@end
