//
//  NXTabItem.h
//  SPATCO JT Installation
//
//  Created by Nexcom on 2/20/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXTabItem : NSObject
/** The text being displayed in the tab. */
@property (nonatomic, copy, readonly) NSString *title;

/** 
 Creates a new @p NXTabItem with the specified title and action.
 
 @param title The text to display in tab.
 @param actionBlock A block to execute the this tab is selected.
 */
+ (instancetype)tabItemWithTitle:(NSString *)title action:(void (^)())actionBlock;

/**
 Calls this tab's actionBlock
 */
- (void)performAction;
@end
