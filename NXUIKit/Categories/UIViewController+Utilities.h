//
//  UIViewController+Utilities.h
//  
//
//  Created by Joseph Sferrazza on 7/8/15.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utilities)

/**
 @return The nested @p UIViewController that contains the content being displayed.  If this view controller is a @p UINavigationController then the @p topViewController is returned.  If this view controller is a @p UISplitViewController then the detail view controller is returned.  This will never return a @p UINavigationController, @p UISplitViewController or @p UITabBarController.
 */
- (UIViewController *)nestedViewController;
@end
