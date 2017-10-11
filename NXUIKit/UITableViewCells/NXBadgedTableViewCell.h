//
//  BadgedTableViewCell.h
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 3/12/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXTableViewCell.h"
@class NXBadgeView;

@interface NXBadgedTableViewCell : NXTableViewCell
@property (nonatomic, assign) NSUInteger badgeNumber;
@property (nonatomic, weak) IBOutlet NXBadgeView *badgeView;
@end
