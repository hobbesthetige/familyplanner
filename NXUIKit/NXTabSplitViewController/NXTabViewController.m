//
//  NXTabViewController.m
//  SPATCO JT Installation
//
//  Created by Nexcom on 2/20/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXTabViewController.h"
#import "NXTabTableViewCell.h"
#import "NXTabItem.h"

@interface NXTabViewController ()
@property (nonatomic, strong) NSIndexPath *selectedRow;
@end

@implementation NXTabViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.tableView.rowHeight = 75.0;
    self.tableView.contentInset = UIEdgeInsetsMake(65, 0, 0, 0);
    
    self.selectedRow = [NSIndexPath indexPathForRow:0 inSection:0];
}

#pragma mark - UIViewController Methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Accessors
- (void)setTabItems:(NSArray *)tabItems {
    _tabItems = tabItems;

    if (self.isViewLoaded && self.view.window) {
        [self.tableView reloadData];
    }
}

#pragma mark - Public
- (void)reselectCurrentTab {
    if (self.selectedRow) {
        [self.tableView selectRowAtIndexPath:self.selectedRow animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tabItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NXTabTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TabCell" forIndexPath:indexPath];
    NSAssert([(self.tabItems)[indexPath.row] isKindOfClass:[NXTabItem class]], @"The tabItems array contains an object that is not a NXTabItem.");
    
    cell.item = (NXTabItem *)(self.tabItems)[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Do nothing if the current tab is reselected.
    if ([indexPath isEqual:self.selectedRow]) {
        return;
    }
    
    NXTabTableViewCell *cell = (NXTabTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.item performAction];
    
    self.selectedRow = indexPath;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
