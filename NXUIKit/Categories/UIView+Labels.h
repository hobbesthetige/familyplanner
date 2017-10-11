//
//  UIView+Labels.h
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 3/13/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Labels)
/**
 Adds a label with the specified text at the center of this view.  Uses the @p UIFontTextStyleSubheadline font.
 
 @see removeCenteredLabel
 */
- (void)addCenteredLabelWithText:(NSString *)text textColor:(UIColor *)color;

/**
 Removes the label that was placed at the center of this view.
 
 @see addCenteredLabelWithText:textColor:
 */
- (void)removeCenteredLabel;
@end
