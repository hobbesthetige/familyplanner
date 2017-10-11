//
//  UITableView+Convenience.m
//  SchedulePro
//
//  Created by Joe Sferrazza on 3/10/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

#import "UITableView+Convenience.h"

@implementation UITableView (Convenience)

- (NSIndexPath *)lastIndexPath {
    if (self.dataSource) {
        NSInteger lastSectionIndex = [self.dataSource numberOfSectionsInTableView:self] - 1;
        if (lastSectionIndex >= 0) {
            NSInteger lastRowIndex = [self.dataSource tableView:self numberOfRowsInSection:lastSectionIndex] - 1;
            
            if (lastRowIndex >= 0) {
                return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
            }
        }
    }
    return nil;
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    NSIndexPath *lastIndexPath = [self lastIndexPath];
    if (lastIndexPath) {
        [self scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

- (void)scrollToTopAnimated:(BOOL)animated {
    if (self.dataSource) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        if ([self.dataSource numberOfSectionsInTableView:self] > path.section && [self.dataSource tableView:self numberOfRowsInSection:0] > path.row) {
            [self scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:animated];
        }
    }
}
@end
