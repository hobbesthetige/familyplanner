//
//  UIViewController+Utilities.m
//  
//
//  Created by Joseph Sferrazza on 7/8/15.
//
//

#import "UIViewController+Utilities.h"

@implementation UIViewController (Utilities)

- (UIViewController *)nestedViewController {
    // If a UINavigationController, UISplitViewController or UITabBarController is found, call this recursivly
    // to avoid returning a nested container view controller
    if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)self;
        return [navController.topViewController nestedViewController];
    }
    else if ([self isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *splitVC = (UISplitViewController *)self;
        UIViewController *detailViewController = [splitVC.viewControllers lastObject];
        return [detailViewController nestedViewController];
    }
    else if ([self isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)self;
        return [tabBarController.selectedViewController nestedViewController];
    }
    return self;
}
@end
