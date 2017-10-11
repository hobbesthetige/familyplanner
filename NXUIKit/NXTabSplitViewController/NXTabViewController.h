//
//  NXTabViewController.h
//  SPATCO JT Installation
//
//  Created by Nexcom on 2/20/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXTabViewController : UITableViewController
@property (nonatomic, copy) NSArray *tabItems;

/**
 Forces the view to reselect the current tab.
 */
- (void)reselectCurrentTab;
@end
