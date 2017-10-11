//
//  BadgedTableViewCell.m
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 3/12/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXBadgedTableViewCell.h"
#import "NXBadgeView.h"

@interface NXBadgedTableViewCell ()

@end

@implementation NXBadgedTableViewCell

- (void)setBadgeNumber:(NSUInteger)badgeNumber {
    _badgeNumber = badgeNumber;
    
    self.badgeView.badgeNumber = badgeNumber;
}
@end
