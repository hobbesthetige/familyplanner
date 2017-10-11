//
//  NXTabbedPageViewController.h
//  NXUIKit
//
//  Created by Joseph Sferrazza on 12/9/15.
//  Copyright å© 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NXTabBarView;
@class NXPageViewController;
@class NXTabbedPageViewController;

@protocol NXTabbedPageDelegate <NSObject>
@optional
- (void)tabbedPageViewController:(NXTabbedPageViewController *)controller selectedPageController:(UIViewController *)pageController withTabTitled:(NSString *)title atIndex:(NSUInteger)index;
@end

@interface NXTabbedPageViewController : UIViewController

@property (weak, nonatomic)   id<NXTabbedPageDelegate>    delegate;

@property (nonatomic, strong, readonly) NXTabBarView *tabBarView;

- (void)configureUsingViewControllers:(NSArray <UIViewController *> *)viewControllers;
- (void)configureUsingViewControllers:(NSArray <UIViewController *> *)viewControllers tabNames:(NSArray <NSString *> *)tabs;

- (void)pageViewController:(NXPageViewController *)controller scrolledToIndex:(NSInteger)index;
- (void)tabView:(NXTabBarView *)view selectedTabTitled:(NSString *)title atIndex:(NSUInteger)index;

@end
