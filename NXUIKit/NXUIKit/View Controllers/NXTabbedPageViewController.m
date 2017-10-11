//
//  NXTabbedPageViewController.m
//  NXUIKit
//
//  Created by Joseph Sferrazza on 12/9/15.
//  Copyright © 2015 Nexcom. All rights reserved.
//

#import "NXTabbedPageViewController.h"
#import "NXPageViewController.h"
#import "NXTabBarView.h"

@import NXConstraintKit;

@interface NXTabbedPageViewController () <NXPageViewControllerDelegate, NXTabBarViewDelegate>
@property (nonatomic, strong, readwrite) NXTabBarView *tabBarView;
@property (nonatomic, copy) NSArray <NSString *>*tabNames;
@end

static CGFloat const TabBarHeight = 44.0;

@implementation NXTabbedPageViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Accessors
- (NXTabBarView *)tabBarView {
    if (!_tabBarView) {
        _tabBarView = [[NXTabBarView alloc] initWithFrame:CGRectMake(0.0, TabBarHeight, CGRectGetWidth(self.view.frame), TabBarHeight)];
    }
    return _tabBarView;
}

- (void)setTabNames:(NSArray<NSString *> *)tabNames {
    _tabNames = tabNames;
    
    [self setUpTabBar];
}

#pragma mark - Public

- (void)configureUsingViewControllers:(NSArray <UIViewController *> *)viewControllers
{
    NSMutableArray * names = [[NSMutableArray alloc] initWithCapacity:viewControllers.count];
    
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [names addObject:obj.title?:@(idx + 1).stringValue];
    }];
    
    
    [self configureUsingViewControllers:viewControllers tabNames:names];
}

- (void)configureUsingViewControllers:(NSArray<UIViewController *> *)viewControllers tabNames:(NSArray<NSString *> *)tabs {
    
    self.tabNames = tabs;
    
    NXPageViewController *pageVC = nil;
    
    if (self.childViewControllers.count == 0) {
        pageVC = [[NXPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        pageVC.pageDelegate = self;
        [self addChildViewController:pageVC];
        [pageVC didMoveToParentViewController:self];
        [self.view addSubview:pageVC.view];
        [pageVC.view makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.tabBarView.bottom);
        }];
    }
    else if ([[self.childViewControllers firstObject] isKindOfClass:[NXPageViewController class]]){
        pageVC = [self.childViewControllers firstObject];
    }
    
    pageVC.pages = viewControllers;
    
}

#pragma mark - Private
- (void)setUpTabBar {
    self.tabBarView.tabNames = self.tabNames;
    self.tabBarView.position = UIBarPositionTop;
    self.tabBarView.backgroundColor = (self.tabBarView.backgroundColor) ? self.tabBarView.backgroundColor : [UIColor colorWithWhite:0.93 alpha:1.0];
    self.tabBarView.delegate = self;
    
    [self.view addSubview:self.tabBarView];
    [self.tabBarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.topMargin);
        make.height.equalTo(TabBarHeight);
    }];
}

#pragma mark - NXPageViewControllerDelegate
- (void)pageViewController:(NXPageViewController *)controller scrolledToIndex:(NSInteger)index {
    self.tabBarView.selectedIndex = index;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabbedPageViewController:selectedPageController:withTabTitled:atIndex:)]) {
        if ([[self.childViewControllers firstObject] isKindOfClass:[NXPageViewController class]]) {
            NXPageViewController *childPageVC = (NXPageViewController *)[self.childViewControllers firstObject];
            
            UIViewController *page = childPageVC.pages[index];
            
            [self.delegate tabbedPageViewController:self selectedPageController:page withTabTitled:self.tabNames[index] atIndex:index];
        }
    }
}

#pragma mark - NXTabBarViewDelegate
- (void)tabView:(NXTabBarView *)view selectedTabTitled:(NSString *)title atIndex:(NSUInteger)index {
    if ([[self.childViewControllers firstObject] isKindOfClass:[NXPageViewController class]]) {
        NXPageViewController *childPageVC = (NXPageViewController *)[self.childViewControllers firstObject];
        [childPageVC scrollToIndex:index];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabbedPageViewController:selectedPageController:withTabTitled:atIndex:)]) {
            UIViewController *page = childPageVC.pages[index];
            [self.delegate tabbedPageViewController:self selectedPageController:page withTabTitled:title atIndex:index];
        }
    }
}
@end
