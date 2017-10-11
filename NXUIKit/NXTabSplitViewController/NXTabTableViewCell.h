//
//  NXTabTableViewCell.h
//  SPATCO JT Installation
//
//  Created by Nexcom on 2/20/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NXTabItem;

@interface NXTabTableViewCell : UITableViewCell
@property (nonatomic, strong) NXTabItem *item;
@end
