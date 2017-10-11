//
//  NXPageViewController.h
//  NXUIKit
//
//  Created by Joseph Sferrazza on 12/9/15.
//  Copyright © 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NXPageViewController;

@protocol NXPageViewControllerDelegate <NSObject>
@optional
- (void)pageViewController:(NXPageViewController *)controller scrolledToIndex:(NSInteger)index;
@end

@interface NXPageViewController : UIPageViewController
@property (nonatomic, strong) NSArray <UIViewController *> *pages;
@property (nonatomic, weak) id<NXPageViewControllerDelegate> pageDelegate;

- (void)scrollToIndex:(NSUInteger)index;
@end
