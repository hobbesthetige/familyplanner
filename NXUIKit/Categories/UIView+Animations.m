//
//  UIView+Animations.m
//  SPATCO JT Installation
//
//  Created by Joseph Sferrazza on 2/24/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "UIView+Animations.h"

@implementation UIView (Animations)

#pragma mark - Public Methods
- (void)shakeConstraint:(NSLayoutConstraint *)constraint {
    [self shakeConstraint:constraint distance:75.0 duration:0.65];
}

- (void)shakeConstraint:(NSLayoutConstraint *)constraint distance:(CGFloat)distance duration:(CGFloat)totalDuration {
    CGFloat startingConstant = constraint.constant;
    constraint.constant = startingConstant + distance;
    [self setNeedsUpdateConstraints];
    
    // Get the duration for each step in the animation
    CGFloat stepDuration = totalDuration / 8.0;
    
    // Animate to the left
    [UIView animateWithDuration:stepDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        constraint.constant = startingConstant - distance;
        [self setNeedsUpdateConstraints];
        // Covering twice the distance so double the duration
        [UIView animateWithDuration:(stepDuration * 2) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            constraint.constant = startingConstant;
            [self setNeedsUpdateConstraints];
            [UIView animateWithDuration:(stepDuration * 5) delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:0.0 options:0 animations:^{
                [self layoutIfNeeded];
            } completion:nil];
        }];
    }];
}

@end
