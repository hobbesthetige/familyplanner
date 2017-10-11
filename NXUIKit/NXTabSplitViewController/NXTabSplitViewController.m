//
//  NXTabSplitViewController.m
//  SPATCO JT Installation
//
//  Created by Joe Sferrazza on 2/20/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXTabSplitViewController.h"
#import "NXTabViewController.h"
#import "NXTabItem.h"
#import <NXUIKit/NXUIKit-Swift.h>

@import NXConstraintKit;

@interface NXTabSplitViewController () <UIToolbarDelegate, UISplitViewControllerDelegate>
@property (nonatomic, strong, readwrite) UIToolbar *topToolbar;
@property (nonatomic, copy, readwrite) NSArray *tabItems;

@property (nonatomic, strong) UIBarButtonItem *displayModeButton;

@end

@implementation NXTabSplitViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self setUpToolbar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self toggleDisplayModeButtonForViewSize:CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - UIViewController Methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self toggleDisplayModeButtonForViewSize:size];
        // Always show the tabs in landscape orientation
        if (size.width > size.height) {
            self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // If the tabs are on-screen make sure the selected tab is highlighted.
        if ([self tabViewController].view.center.x > 0) {
            [[self tabViewController] reselectCurrentTab];
        }
    }];
}

#pragma mark - Custom Accessors
- (UIBarButtonItem *)displayModeButton {
    if (!_displayModeButton) {
        _displayModeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_menu_25"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleDisplayMode)];
    }
    return _displayModeButton;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.topToolbar.bounds];
        _titleLabel.text = @"";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIToolbar *)topToolbar {
    if (!_topToolbar) {
        NSAssert([NXUIKitManager defaultManager].statusBarFrameHandler, @"%@ requires that the NXUIKitManager has a non-nil statusBarFrameHandler.", self);
        CGRect statusBarFrame = [NXUIKitManager defaultManager].statusBarFrameHandler();
        CGFloat originY = CGRectGetHeight(statusBarFrame);
        _topToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, originY, CGRectGetWidth(self.view.bounds), 44.0)];
        _topToolbar.delegate = self;
        _topToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_topToolbar addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_topToolbar);
        }];
        _topToolbar.items = @[self.displayModeButton]; // Use our own button, I'm not a fan of the default
    }
    return _topToolbar;
}

- (void)setDataSource:(id<NXTabSplitViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

- (void)setTabColumnWidth:(CGFloat)tabColumnWidth {
    _tabColumnWidth = tabColumnWidth;
    self.maximumPrimaryColumnWidth = tabColumnWidth;
    self.minimumPrimaryColumnWidth = tabColumnWidth;
}

- (void)setTitle:(NSString *)title {
    super.title = title;
    
    self.titleLabel.text = title;
}

#pragma mark - Public Instance Methods
- (void)reloadData {
    if ([self.dataSource respondsToSelector:@selector(tabItemsForTabSplitViewController:)]) {
        self.tabItems = [self.dataSource tabItemsForTabSplitViewController:self];
        [self tabViewController].tabItems = self.tabItems;
    }
}

- (void)selectTabTitled:(NSString *)title {
    NSUInteger index = 0;
    for (NXTabItem *item in self.tabItems) {
        if ([item.title isEqualToString:title]) {
            [self selectTabAtIndex:index];
            break;
        }
        index++;
    }
}

- (void)selectTabAtIndex:(NSUInteger)index {
    if ([[self tabViewController].tableView numberOfRowsInSection:0] > index) {
        [[self tabViewController].tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)setTopToolbarItems:(NSArray *)items animated:(BOOL)animate {
    NSMutableArray *existingItems = [self.topToolbar.items mutableCopy];
    [existingItems addObjectsFromArray:items];
    [self.topToolbar setItems:[existingItems copy] animated:animate];
}

#pragma mark - Private Instance Methods
- (void)setUpToolbar {
    [self.view addSubview:self.topToolbar];
}

/**
 @returns The @p NXTabViewController nested in the left side of this split view controller.
 */
- (NXTabViewController *)tabViewController {
    UIViewController *vc = (self.viewControllers).firstObject;
    
    if ([vc isKindOfClass:[NXTabViewController class]]) {
        return (NXTabViewController *)vc;
    }
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)vc;
        if ([navController.topViewController isKindOfClass:[NXTabViewController class]]) {
            return (NXTabViewController *)navController.topViewController;
        }
    }
    return nil;
}

- (void)toggleDisplayMode {
    if (self.displayMode == UISplitViewControllerDisplayModeAllVisible || self.displayMode == UISplitViewControllerDisplayModeAutomatic) {
        self.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
    }
    else {
        self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    }
}

- (void)toggleDisplayModeButtonForViewSize:(CGSize)size {
    if (size.width > size.height) {
        if ([self.topToolbar.items containsObject:self.displayModeButton]) {
            NSMutableArray *items = [self.topToolbar.items mutableCopy];
            [items removeObject:self.displayModeButton];
            [self.topToolbar setItems:[items copy] animated:YES];
        }
    }
    else {
        if (![self.topToolbar.items containsObject:self.displayModeButton]) {
            NSMutableArray *items = [self.topToolbar.items mutableCopy];
            [items insertObject:self.displayModeButton atIndex:0];
            [self.topToolbar setItems:[items copy] animated:YES];
        }
    }
}

#pragma mark - UIToolbarDelegate
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    if ([bar isEqual:self.topToolbar]) {
        return UIBarPositionTopAttached;
    }
    return UIBarPositionAny;
}

@end
