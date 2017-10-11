//
//  NXListTableViewController.h
//  NXUIKit
//
//  Created by Joe Sferrazza on 4/14/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

/** A generic @p UITableViewController that displays a list of items. Items must conform to the @p ListItemProtocol and reside inside a @p UINavigationController. */
@interface NXListTableViewController : UITableViewController

/** Whether or not multiple selections are allowed.  If set to @p NO, the completionBlock is called when a selection is made. @p NO by default. */
@property (nonatomic, assign) BOOL allowsMultipleSelections;

/** Whether or not to display a @p UISearchBar in the @p UITableView's header. @p NO by default. */
@property (nonatomic, assign) BOOL allowsSearching;

/** The title to use in the right @p UIBarButtonItem.  Tapping this button executes the completionBlock */
@property (nonatomic, copy) NSString *completionButtonTitle;

/** The items to display in the @p UITableView.  All items must conform to the @p ListItemProtocol */
@property (nonatomic, copy) NSArray *listItems;

/** Setting this value sets the preferred width for this view controller.  The height is automatically set to the height required to display all items. 320.0 by default .*/
@property (nonatomic, assign) CGFloat preferredWidth;

/** Whether or not the list should be sorted by title before being displayed.  @p NO by defualt.
 @note This must be set before setting the @p listItems array. */
@property (nonatomic, assign) BOOL shouldSortByTitle;

/** Whether or not to display a loading indicator if the view appears before the @p listItems array is populated.  The indicator is automatically removed when the @p listItem array is set.  @p NO by defualt. */
@property (nonatomic, assign) BOOL shouldShowActivityIndicatorWhenViewAppearsWithNoItems;

/** A block to execute when the user has made their selections.  If @p allowsMultipleSelections is @p NO then this is called after the user makes one selection, otherwise this is called when the user taps the right bar button item. */
@property (nonatomic, copy) void (^completionBlock)(NSArray *selections);

/** A block to execute when the user taps the left bar button item.  If this is nil, no left bar button item will be added to the UI. */
@property (nonatomic, copy) void (^cancellationBlock)();

/** An @p NSArray of items to preselect in the tableview when it's first displayed. */
@property (nonatomic, copy) NSArray *initialSelections;
@end
