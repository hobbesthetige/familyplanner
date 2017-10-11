//
//  ViewControllerAnimators.h
//  NXUIKit
//
//  Created by Joe Sferrazza on 4/7/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface NavigationControllerUpAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@end

@interface NavigationControllerDownAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@end

@interface ModalUpAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@end

@interface ModalDownAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@end