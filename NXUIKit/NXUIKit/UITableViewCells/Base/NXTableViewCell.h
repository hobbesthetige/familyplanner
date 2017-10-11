//
//  NXTableViewCell.h
//  SPATCO JT Installation
//
//  Created by Joseph Sferrazza on 2/26/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;

/** The number of lines allowed to be displayed in the cell's value label. */
@property (nonatomic, assign) NSUInteger numberOfValueLines;

/** The title text for this cell. */
@property (nonatomic, copy) NSString *title;

/** The value text for this cell. */
@property (nonatomic, copy) NSString *value;

/** Whether or not to hide the value label while this cell is editing. @p NO by default. */
@property (nonatomic, assign) BOOL hideValueWhileEditing;

/**  */
@property (nonatomic, copy) void (^editBlock)(id newValue);

/** @return The preferred height for this cell that can be used when not using @p UITableViewAutomaticDimension. */
+ (CGFloat)preferredHeight;
@end
