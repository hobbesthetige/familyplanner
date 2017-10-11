//
//  ViewControllerAnimators.m
//  NXUIKit
//
//  Created by Joe Sferrazza on 4/7/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "ViewControllerAnimators.h"

static CGFloat const AnimationDuration = 0.5;

#pragma mark - NavigationController
@implementation NavigationControllerUpAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *source = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    destination.view.alpha = 0.0;
    destination.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    [[transitionContext containerView] addSubview:destination.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.75 initialSpringVelocity:0.0 options:0 animations:^{
        source.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
        destination.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        source.view.alpha = 0.0;
        destination.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
        source.view.alpha = 1.0;
        source.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return AnimationDuration;
}
@end

@implementation NavigationControllerDownAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *source = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    destination.view.alpha = 0.0;
    destination.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    [[transitionContext containerView] addSubview:destination.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.75 initialSpringVelocity:0.0 options:0 animations:^{
        destination.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        source.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
        source.view.alpha = 0.0;
        destination.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
        source.view.alpha = 1.0;
        source.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return AnimationDuration;
}
@end



#pragma mark - Modal
@implementation ModalUpAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    destination.view.alpha = 0.0;
    destination.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.25, 0.25);
    [[transitionContext containerView] addSubview:destination.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:0 animations:^{
        destination.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        destination.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return AnimationDuration;
}
@end

@implementation ModalDownAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *source = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.65 initialSpringVelocity:0.0 options:0 animations:^{
        source.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.25, 0.25);
        source.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
        source.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return AnimationDuration;
}
@end

