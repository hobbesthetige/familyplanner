//
//  NXListTableViewController.m
//  NXUIKit
//
//  Created by Joe Sferrazza on 4/14/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXListTableViewController.h"
#import "NXListItemProtocol.h"
#import "NXIndicatorView.h"
#import "UIFont+System.h"

@interface NXListTableViewController () <UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *selections;
@property (nonatomic, strong) NXIndicatorView *loadingView;
@property (nonatomic, strong) NSMutableArray *filteredItems;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

static CGFloat const SearchBarHeight = 44.0;

@implementation NXListTableViewController

#pragma mark - UIViewController - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.tableView.rowHeight = 50.0;
    
    if (self.allowsSearching) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), SearchBarHeight)];
        self.searchBar.delegate = self;
        self.tableView.tableHeaderView = self.searchBar;
    }
    
    [self updateContentSize];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.allowsMultipleSelections) {
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.completionButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(doneWasTapped:)];
        self.navigationItem.rightBarButtonItem = doneButtonItem;
    }
    
    if (self.cancellationBlock) {
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelWasTapped:)];
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
    }
    
    if (!self.allowsMultipleSelections) {
        [self.selections removeAllObjects];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.listItems && self.shouldShowActivityIndicatorWhenViewAppearsWithNoItems) {
        self.loadingView = [NXIndicatorView showIndicatorWithStyle:NXIndicatorViewStyleActivity superview:self.view title:NSLocalizedString(@"Loading", nil) disableInteraction:YES];
    }
}

#pragma mark - UIViewController
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Accessors - Getters
- (NSString *)completionButtonTitle {
    if (!_completionButtonTitle) {
        _completionButtonTitle = NSLocalizedString(@"Done", nil);
    }
    return _completionButtonTitle;
}

- (CGFloat)preferredWidth {
    if (!_preferredWidth) {
        _preferredWidth = 320.0;
    }
    return _preferredWidth;
}

- (NSMutableArray *)selections {
    if (!_selections) {
        _selections = self.initialSelections ? [self.initialSelections mutableCopy] : [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _selections;
}

#pragma mark - Custom Accessors - Setters
- (void)setAllowsMultipleSelections:(BOOL)allowsMultipleSelections {
    _allowsMultipleSelections = allowsMultipleSelections;
    
    [self.tableView setAllowsMultipleSelection:allowsMultipleSelections];
    
    if (allowsMultipleSelections) {
        NSAssert(self.navigationController, @"Instances of @% must reside inside a @p UINavigationController when allowsMultipleSelections is set to YES", NSStringFromClass([self class]));
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWasTapped:)];
        self.navigationItem.rightBarButtonItem = doneButtonItem;
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)setAllowsSearching:(BOOL)allowsSearching {
    _allowsSearching = allowsSearching;
    
    if (allowsSearching && self.isViewLoaded) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), SearchBarHeight)];
        self.searchBar.delegate = self;
        self.tableView.tableHeaderView = self.searchBar;
    }
}

- (void)setListItems:(NSArray *)items {
    if (self.shouldSortByTitle) {
        items = [items sortedArrayUsingComparator:^NSComparisonResult(id<NXListItemProtocol> obj1, id<NXListItemProtocol> obj2) {
            return [[obj1 listTitle] compare:[obj2 listTitle] options:NSCaseInsensitiveSearch];
        }];
    }
    
    _listItems = items;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.loadingView hide];
        [self filterListAndReloadTable];
        [self updateContentSize];
    }];
}

#pragma mark - Actions
- (void)cancelWasTapped:(id)sender {
    if (self.cancellationBlock) {
        self.cancellationBlock();
    }
}

- (void)doneWasTapped:(id)sender {
    if (self.completionBlock) {
        self.completionBlock([self.selections copy]);
    }
}

#pragma mark - Private
- (void)filterListAndReloadTable {
    if (self.searchBar.text.length == 0) {
        self.filteredItems = [self.listItems mutableCopy];
    }
    else {
        self.filteredItems = [[NSMutableArray alloc] init];
        
        for (id<NXListItemProtocol> item in self.listItems) {
            if ([[item listTitle] localizedCaseInsensitiveContainsString:self.searchBar.text]) {
                [self.filteredItems addObject:item];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)updateContentSize {
    // Only update the content size if we're in a popover - ex. we don't want to update when presented in a modal form sheet.
    if (self.navigationController.isModalInPopover || self.isModalInPopover) {
        CGFloat contentHeight = self.tableView.rowHeight * self.listItems.count;
        contentHeight += self.allowsSearching ? SearchBarHeight : 0.0;
        self.preferredContentSize = CGSizeMake(self.preferredWidth, contentHeight);
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"SingleValue";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont nx_systemFontOfSize:15.0 weight:NX_UIFontWeightLight];
        cell.detailTextLabel.font = [UIFont nx_systemFontOfSize:12.0 weight:NX_UIFontWeightLight];
    }
    id <NXListItemProtocol> listItem = [self.filteredItems objectAtIndex:indexPath.row];
    cell.textLabel.text = [listItem listTitle];
    cell.detailTextLabel.text = [listItem respondsToSelector:@selector(listValue)] ? [listItem listValue] : @"";
    cell.imageView.image = [listItem respondsToSelector:@selector(listImage)] ? [listItem listImage] : nil;
    
    if (self.allowsMultipleSelections) {
        cell.accessoryType = [self.selections containsObject:listItem] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.filteredItems objectAtIndex:indexPath.row];
    
    if ([self.selections containsObject:item]) {
        [self.selections removeObject:item];
    }
    else {
        [self.selections addObject:item];
    }
    
    if (!self.allowsMultipleSelections && self.completionBlock) {
        self.completionBlock([self.selections copy]);
    }
    
    if (self.allowsMultipleSelections) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterListAndReloadTable];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self filterListAndReloadTable];
}

@end
