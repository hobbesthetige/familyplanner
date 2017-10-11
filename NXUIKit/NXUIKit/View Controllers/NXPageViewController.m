//
//  NXPageViewController.m
//  NXUIKit
//
//  Created by Joseph Sferrazza on 12/9/15.
//  Copyright © 2015 Nexcom. All rights reserved.
//

#import "NXPageViewController.h"

#import "UIViewController+Utilities.h"

@interface NXPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (assign, nonatomic)   BOOL isTransitioning;

@end

@implementation NXPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = self;
    self.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setPages:(NSArray<UIViewController *> *)pages {
    _pages = pages;
    [self setUpViewControllers];
}

#pragma mark - Public
- (void)scrollToIndex:(NSUInteger)index {
    
    if (self.isTransitioning) return;
    
    // Determine the current index being displayed
    // [self.viewControllers firstObject] always returns the current view controller
    NSInteger __block currentIndex = 0;
    [self.pages enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        if ([viewController isEqual:[self.viewControllers firstObject]]) {
            currentIndex = idx;
            *stop = YES;
        }
    }];
    
    if (currentIndex == index) return;
    
    self.isTransitioning = YES;
    
    // Determine which direction to scroll
    UIPageViewControllerNavigationDirection direction = currentIndex < index ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    
    UIViewController *controller = [self.pages objectAtIndex:index];
    
    __weak typeof (self) welf = self;
    
    [self setViewControllers:@[controller] direction:direction  animated:YES completion:^(BOOL finished) {
        
        welf.isTransitioning = NO;
    }];
}

#pragma mark - Private
- (void)setUpViewControllers {
    // Get the array from our datasource
    NSAssert(self.pages.count > 0, @"NXPageViewControllerDataSource must specify at least 1 view controller");
    
    if ([self.pages firstObject]) {
        [self setViewControllers:@[[self.pages firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    UIViewController __block *vcToReturn = nil;
    [self.pages enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        if ([vc isEqual:viewController] && (idx + 1) < self.pages.count) {
            vcToReturn = [self.pages objectAtIndex:idx + 1];
        }
    }];
    return vcToReturn;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    UIViewController __block *vcToReturn = nil;
    [self.pages enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        if ([vc isEqual:viewController] && idx != 0) {
            vcToReturn = [self.pages objectAtIndex:idx - 1];
        }
    }];
    return vcToReturn;
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pvc didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    self.isTransitioning = NO;
    
    if (completed) {
        [self.pages enumerateObjectsUsingBlock:^(UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *activeViewController = [pvc.viewControllers firstObject];
            
            if ([activeViewController isEqual:vc]) {
                [self.pageDelegate pageViewController:self scrolledToIndex:idx];
                *stop = YES;
            }
        }];
    }
}

@end
