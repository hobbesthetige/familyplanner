//
//  UITableView+Convenience.h
//  SchedulePro
//
//  Created by Joe Sferrazza on 3/10/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Convenience)
- (NSIndexPath *)lastIndexPath;
- (void)scrollToBottomAnimated:(BOOL)animated;
- (void)scrollToTopAnimated:(BOOL)animated;
@end
