//
//  NXWeekPickerCollectionViewController.h
//  WeekPicker
//
//  Created by Daniel Meachum on 11/20/14.
//  Copyright (c) 2014 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NXDatePickerSelectionHandler)(NSDate *startDate, NSDate *endDate);

typedef NSArray *(^NXDatePickerEventsForDate)(NSDate *date);

typedef NS_ENUM(NSUInteger, SelectionType) {
    SelectionTypeSingleDay,
    SelectionTypeWeek,
    SelectionTypeMonth
};

@class NXDatePickerCollectionViewController;

@protocol NXDatePickerDelegate;

@interface NXDatePickerCollectionViewController : UICollectionViewController

@property (readonly, nonatomic) NSCalendar *calendar;
@property (readonly, nonatomic) NSDate     *startDate;
@property (readonly, nonatomic) NSDate     *firstDate;
@property (readonly, nonatomic) NSDate     *lastDate;

@property (readonly, nonatomic) NSDate     *selectedStartDate;
@property (readonly, nonatomic) NSDate     *selectedEndDate;

@property (strong, nonatomic)   UIColor    *separatorColor;

@property (assign, nonatomic)   SelectionType selectionType;
@property (assign, nonatomic)   BOOL selectionEnabled;

@property (copy, nonatomic)     NXDatePickerSelectionHandler    selectionHandler;

@property (weak, nonatomic)   id<NXDatePickerDelegate>    delegate;

- (instancetype)initWithStartDate:(NSDate *)startDate;
- (instancetype)initWithStartDate:(NSDate *)startDate firstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate;

/** When instantiating from a storyboard you must call @p configureUsingStartDate: or configureUsingStartDate:firstDate:lastDate: before the view is loaded. */
- (void)configureUsingStartDate:(NSDate *)startDate;

/** When instantiating from a storyboard you must call @p configureUsingStartDate: or configureUsingStartDate:firstDate:lastDate: before the view is loaded. */
- (void)configureUsingStartDate:(NSDate *)startDate firstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate;

- (void)scrollNearestToDate:(NSDate *)date animated:(BOOL)animated;


+ (NSDate *)threeMonthsFromDate:(NSDate *)date;
+ (NSDate *)threeMonthsToDate:(NSDate *)date;

@end

@protocol NXDatePickerDelegate <NSObject>

@optional

- (void)datePicker:(NXDatePickerCollectionViewController *)picker didSelectStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (void)datePickerDidBeginScrolling:(NXDatePickerCollectionViewController *)picker;
- (void)datePickerDidEndScrolling:(NXDatePickerCollectionViewController *)picker;
- (void)datePicker:(NXDatePickerCollectionViewController *)picker willScrollToBeginningOfMonth:(NSDate *)firstDateInMonth;

@property (copy, nonatomic)     NXDatePickerEventsForDate    eventsForDateHandler;

@end