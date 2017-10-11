//
//  UIView+Loading.h
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 4/3/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Loading)
/**
 Hides this view and places an animating activity indicator at it's center.
 
 @see showAsLoadedWithResults
 @see showAsLoadedWithoutResults
 */
- (void)showAsLoading;

/**
 Animates the view's alpha back to 1 and removes the activity indicator.
 */
- (void)showAsLoadedWithResults;

/**
 Removes the activity indicator and places a label with the specified text at the view's center.  Uses the @p UIFontTextStyleFootnote font.
 
 @param message The message to display at the center of the view.
 */
- (void)showAsLoadedWithoutResults:(NSString *)message;

/**
 Removes the activity indicator and places a label with the specified text and font at the view's center.
 
 @param message The message to display at the center of the view.
 @param font The font to use
 */
- (void)showAsLoadedWithoutResults:(NSString *)message font:(UIFont *)font;

/**
 Removes the activity indicator and places a label with the specified text and font at the view's center.
 
 @param message The message to display at the center of the view.
 @param font The font to use
 @param color The text color to use
 */
- (void)showAsLoadedWithoutResults:(NSString *)message font:(UIFont *)font textColor:(UIColor *)color;
@end
