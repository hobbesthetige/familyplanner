//
//  DateSelectionViewController.h
//  SPATCO JT Installation
//
//  Created by Joe Sferrazza on 3/3/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const DateSelectionStoryboardIdentifier;
@interface NXDateSelectionViewController : UIViewController

/** The date picker countdown duration (in seconds).*/
@property (nonatomic, assign) NSTimeInterval countdownDuration;

/** The date displayed by the view controller. If left @p nil, this will default to today's date. */
@property (nonatomic, strong) NSDate *date;

/** The date picker minute interval. 1 by default. Must be between 1 and 30. */
@property (nonatomic, assign) NSInteger minuteInterval;

/** The date picker mode to use. @p UIDatePickerModeDate by default. */
@property (nonatomic, assign) UIDatePickerMode datePickerMode;

/** The maximum to date to allow in the date picker.  This is optional. */
@property (nonatomic, strong) NSDate *maximumDate;

/** The message to display above the date picker.  This is optional. */
@property (nonatomic, copy) NSString *message;

/** The font to use in the message label */
@property (nonatomic, strong) UIFont *messageFont;

/** The minimum to date to allow in the date picker.  This is optional. */
@property (nonatomic, strong) NSDate *minimumDate;

/** Whether or not to display a label below the picker showing the selected date.  This is always hidden when using @p UIDatePickerModeCountDownTimer. */
@property (nonatomic, assign) BOOL showsBottomDateLabel;

/** A block to execute when a new date is selected.  This is called each time the date picker stops on a new date. */
@property (nonatomic, copy) void (^updateBlock)(NSDate *newDate);

/** @return A new instance of a @p NXDateSelectionViewController */
+ (instancetype)dateSelectionViewController;

@end
