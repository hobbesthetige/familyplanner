//
//  UIView+Animations.h
//  SPATCO JT Installation
//
//  Created by Joseph Sferrazza on 2/24/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animations)
/**
 Shakes the specified constraint back and forth.  Mimics the effect shown when entering an incorrect password into the OS X logon screen.
 
 @param constraint The constraint to move back and forth.  This constraint must reside in this view.
 @param distance The total distance to one side that the constraint should be moved.
 @param totalDuration The total duration of the animation.
 */
- (void)shakeConstraint:(NSLayoutConstraint *)constraint distance:(CGFloat)distance duration:(CGFloat)totalDuration;

/**
 Shakes the specified constraint back and forth using a distance of 75 and a duration of 0.65 seconds.  Mimics the effect shown when entering an incorrect password into the OS X logon screen.
 
 @param constraint The constraint to move back and forth.  This constraint must reside in this view.
 */
- (void)shakeConstraint:(NSLayoutConstraint *)constraint;
@end
