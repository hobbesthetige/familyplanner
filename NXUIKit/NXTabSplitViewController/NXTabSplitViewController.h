//
//  NXTabSplitViewController.h
//  SPATCO JT Installation
//
//  Created by Joe Sferrazza on 2/20/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NXTabSplitViewController;

@protocol NXTabSplitViewControllerDataSource <NSObject>
- (NSArray *)tabItemsForTabSplitViewController:(NXTabSplitViewController *)tabController;
@end

/** A @p UISplitViewContoller that displays tabs vertically along the left edge of the view.  Note: This is incomplete - the UI of the tabs (image & text) must be laid out and connected in a storybaord. */
@interface NXTabSplitViewController : UISplitViewController

/** The width of the tab view controller displayed on the left side of the view. */
@property (nonatomic, assign) CGFloat tabColumnWidth;

/** The label displayed in the center of the top toolbar.  */
@property (nonatomic, strong) UILabel *titleLabel;

/** An @p NSArray of @p NXTabItems currently being displayed. */
@property (nonatomic, copy, readonly) NSArray *tabItems;

/** The @p UIToolbar that is displayed across the top edge of the view. */
@property (nonatomic, strong, readonly) UIToolbar *topToolbar;

/** @see @p NXTabSplitViewControllerDataSource */
@property (nonatomic, weak) id <NXTabSplitViewControllerDataSource> dataSource;

/** Reloads all tabs from the @p NXTabSplitViewControllerDataSource */
- (void)reloadData;

/** Sets the @p UIBarButtonItems to display in the top toolbar. */
- (void)setTopToolbarItems:(NSArray *)items animated:(BOOL)animate;

/** Selects the tab matching the specified title. The title must match exactly. Does nothing if a tab with this title was not found. */
- (void)selectTabTitled:(NSString *)title;

/** Selects the tab at the specified index. Does nothing if the index is out of bounds. */
- (void)selectTabAtIndex:(NSUInteger)index;

@end
