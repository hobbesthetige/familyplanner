//
//  NXWeekPickerCollectionViewController.m
//  WeekPicker
//
//  Created by Daniel Meachum on 11/20/14.
//  Copyright (c) 2014 Nexcom. All rights reserved.
//

#import "NXDatePickerCollectionViewController.h"
#import "NXWeekPickerLayout.h"
#import "NXWeekDayCellCollectionViewCell.h"
#import "NXWeekDaySeparatorCollectionReusableView.h"
#import "NXWeekDayHeaderCollectionReusableView.h"
#import "NXWeekDayMonthCollectionReusableView.h"
#import "NSDate+BeginningEnding.h"

#define NX_MINUTE 60.f
#define NX_HOUR   NX_MINUTE * 60.f
#define NX_DAY    NX_HOUR * 24.f
#define NX_WEEK   NX_DAY * 7.f
#define NX_YEAR   NX_DAY * 365.f

@interface NXDatePickerCollectionViewController () <UIScrollViewDelegate>

@property (strong, nonatomic)   NSMutableArray    *monthDates;

@property (assign, nonatomic)   BOOL initialContentScrolled;
@property (nonatomic, readwrite) NSDate *startDate;
@end

@implementation NXDatePickerCollectionViewController

static NSInteger const DaysInWeek = 7;
static NSString * const reuseIdentifier = @"Cell";
static NSString * const reuseIdentifierSeparator = @"Separator";
static NSString * const reuseIdentifierMonthHeader = @"Header";
static NSString * const reuseIdentifierDaySeparator = @"DaySeparator";
static NSString * const reuseIdentifierDay = @"Day";
static NSString * const reuseIdentifierScrolling = @"Scrolling";

static NSString * const kindSeparator = @"Separator";

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithStartDate:(NSDate *)startDate
{
    NXWeekPickerLayout *layout = [[NXWeekPickerLayout alloc] init];
    
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _startDate = startDate;
        [self initialize];
    }
    return self;
}

- (instancetype)initWithStartDate:(NSDate *)startDate firstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate
{
    NXWeekPickerLayout *layout = [[NXWeekPickerLayout alloc] init];
    
    self = [self initWithCollectionViewLayout:layout];
    if (self) {
        _startDate = startDate;
        _firstDate = firstDate;
        _lastDate = lastDate;
        [self initialize];
    }
    return self;
}

- (void)configureUsingStartDate:(NSDate *)startDate {
    [self configureUsingStartDate:startDate firstDate:nil lastDate:nil];
}

- (void)configureUsingStartDate:(NSDate *)startDate firstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
    _startDate = startDate;
    _firstDate = firstDate;
    _lastDate = lastDate;
    [self initialize];
}

- (void)initialize
{
    _selectionEnabled = YES;
    _selectionType = SelectionTypeSingleDay;
    if (!self.firstDate) _firstDate = [self.startDate beginningOfYear];
    if (!self.lastDate) _lastDate = [self.startDate endOfYear];
    _separatorColor = [UIColor colorWithRed:.85f green:.85f blue:.85f alpha:1.f];
    
    [self populateMonthDates];
    NSIndexPath *startDateIndexPath = [self indexPathForDate:self.startDate];
    [self selectWeekCellsForInitialIndexPath:startDateIndexPath];
}

- (NSDate *)startDate {
    if (!_startDate) {
        _startDate = [NSDate date];
    }
    return _startDate;
}

- (void)setSelectionType:(SelectionType)selectionType
{
    _selectionType = selectionType;
    
    NSIndexPath *startDateIndexPath = [self indexPathForDate:self.startDate];
    [self selectWeekCellsForInitialIndexPath:startDateIndexPath];
}

- (void)populateMonthDates
{
    NSMutableArray *monthDates = @[].mutableCopy;
    
    NSDate *date = self.firstDate;
    while ([date compare:self.lastDate] == NSOrderedAscending) {
        date = [date beginningOfMonth];
        [monthDates addObject:date];
        
        date = [self dateByAddingMonth:date];
    }
    
    self.monthDates = monthDates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:.96f green:.96f blue:.96f alpha:1.f];
    self.collectionView.allowsMultipleSelection = (self.selectionType == SelectionTypeWeek || self.selectionType == SelectionTypeMonth);
    
    // Register cell classes
    [self.collectionView registerClass:[NXWeekDayCellCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[NXWeekDaySeparatorCollectionReusableView class] forSupplementaryViewOfKind:KindLine withReuseIdentifier:reuseIdentifierSeparator];
    [self.collectionView registerClass:[NXWeekDaySeparatorCollectionReusableView class] forSupplementaryViewOfKind:KindVerticalLine withReuseIdentifier:reuseIdentifierDaySeparator];
    [self.collectionView registerClass:[NXWeekDayMonthCollectionReusableView class] forSupplementaryViewOfKind:KindMonthHeader withReuseIdentifier:reuseIdentifierMonthHeader];
    [self.collectionView registerClass:[NXWeekDayHeaderCollectionReusableView class] forSupplementaryViewOfKind:KindDay withReuseIdentifier:reuseIdentifierDay];
    [self.collectionView registerClass:[NXWeekDayMonthScrollCollectionReusableView class] forSupplementaryViewOfKind:KindMonthScroll withReuseIdentifier:reuseIdentifierScrolling];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!self.initialContentScrolled) {
        NSIndexPath *startDateIndexPath = [self indexPathForDate:self.startDate];
        [self scrollToVisibleMonthForSection:startDateIndexPath.section animated:NO];
        [self selectWeekCellsForInitialIndexPath:startDateIndexPath];
        
        self.initialContentScrolled = YES;
    }
    
}

- (void)scrollNearestToDate:(NSDate *)date animated:(BOOL)animated
{
    NSIndexPath *indexPath = [self indexPathForDate:date];
    if (!indexPath) return;
    
    [self scrollToVisibleMonthForSection:indexPath.section animated:animated];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.monthDates.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDate *monthDate = self.monthDates[section];
    NSInteger daysInMonth = [self visibleDaysInMonth:monthDate] + 1;
    
    return daysInMonth;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NXWeekDayCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDate *monthDate = self.monthDates[indexPath.section];
    NSDate *firstDateInMonth = [self firstVisibleDayOfMonth:monthDate];
    
    NSUInteger day = indexPath.item;
    
    NSDateComponents *components =
    [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                    fromDate:firstDateInMonth];
    components.day += day;
    
    cell.date = [[NSCalendar currentCalendar] dateFromComponents:components];
    cell.separatorColor = self.separatorColor;
    
    NSDateComponents *monthCompareComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:cell.date];
    NSDateComponents *monthComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:monthDate];
    cell.enabled = (monthComponents.month == monthCompareComponents.month);
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSDate *monthDate = self.monthDates[indexPath.section];
    
    if ([kind isEqualToString:KindLine]) {
        NXWeekDaySeparatorCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifierSeparator forIndexPath:indexPath];
        
        view.backgroundColor = self.separatorColor;
        
        return view;
    } else if ([kind isEqualToString:KindVerticalLine]) {
        NXWeekDaySeparatorCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifierDaySeparator forIndexPath:indexPath];
        
        view.backgroundColor = self.separatorColor;
        
        return view;
    } else if ([kind isEqualToString:KindMonthHeader]) {
        NXWeekDayMonthCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifierMonthHeader forIndexPath:indexPath];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MMMM yyyy";
        
        view.monthLabel.text = [dateFormatter stringFromDate:monthDate];
        
        return view;
    }  else if ([kind isEqualToString:KindDay]) {
        NXWeekDayHeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifierDay forIndexPath:indexPath];
        
        NSDate *firstDateInMonth = [self firstVisibleDayOfMonth:monthDate];
        
        NSUInteger day = indexPath.item - 1;
        
        NSDateComponents *components =
        [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                        fromDate:firstDateInMonth];
        components.day += day;
        
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EEE";
        
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        view.dayLabel.text = dateString;
        view.currentDate = [self weekdayIsToday:date];
        
        return view;
    } else if ([kind isEqualToString:KindMonthScroll]) {
        NXWeekDayMonthCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifierScrolling forIndexPath:indexPath];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MMMM yyyy";
        
        view.monthLabel.text = [dateFormatter stringFromDate:monthDate];
        view.backgroundColor = [self.collectionView.backgroundColor colorWithAlphaComponent:0.75];
        
        return view;
    }
    
    return nil;
}

- (NSIndexPath *)indexPathForCurrentDate
{
    return [self indexPathForDate:[NSDate date]];
}

- (NSIndexPath *)indexPathForDate:(NSDate *)matchingDate
{
    NSDateComponents *components =
    [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                    fromDate:matchingDate];
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSDate *firstDayOfMonth = [date beginningOfMonth];
    
    if ([self.monthDates containsObject:firstDayOfMonth]) {
        for (int i = 0; i < [self visibleDaysInMonth:firstDayOfMonth]; i++) {
            
            NSDateComponents *components =
            [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                            fromDate:firstDayOfMonth];
            components.day += i;
            
            NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
            
            components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                                         fromDate:matchingDate];
            
            NSDate *finalDate = [[NSCalendar currentCalendar] dateFromComponents:components];
            
            NSInteger extraDaysAtBeginningOfMonth = [self extraDaysAtBegenningOfMonth:firstDayOfMonth];
            
            if ([date isEqualToDate:finalDate]) {
                return [NSIndexPath indexPathForItem:i + extraDaysAtBeginningOfMonth inSection:[self.monthDates indexOfObject:firstDayOfMonth]];
            }
        }
    }
    
    return nil;
}

- (void)selectWeekCellsForInitialIndexPath:(NSIndexPath *)initialIndexPath
{
    NSDate *monthDate = self.monthDates[initialIndexPath.section];
    
    NSDate *firstDateInMonth = [self firstVisibleDayOfMonth:monthDate];
    
    NSUInteger day = initialIndexPath.item ;
    
    NSDateComponents *components =
    [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                    fromDate:firstDateInMonth];
    components.day += day;
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    
    if (self.selectionType == SelectionTypeSingleDay) {
        _selectedStartDate = date;
        _selectedEndDate = date;
        
        if (self.isViewLoaded) [self.collectionView selectItemAtIndexPath:initialIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    else if (self.selectionType == SelectionTypeWeek) {
        NSDate *beginningOfWeek = [date beginningOfWeek];
        _selectedStartDate = beginningOfWeek;
        
        NSMutableArray *indexPaths = @[].mutableCopy;
        for (int i = 0; i < DaysInWeek; i ++) {
            
            NSDateComponents *dayComponents =
            [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                            fromDate:beginningOfWeek];
            dayComponents.day += i;
            
            NSDate *dayDate = [[NSCalendar currentCalendar] dateFromComponents:dayComponents];
            
            NSIndexPath *indexPath = [self indexPathForDate:dayDate];
            
            if (indexPath)
                [indexPaths addObject:indexPath];
            
            _selectedEndDate = dayDate;
        }
        
        if (self.isViewLoaded) {
            for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
                [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
            }
            for (NSIndexPath *indexPath in indexPaths) {
                [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
    }
    else if (self.selectionType == SelectionTypeMonth) {
        NSDate *beginningOfMonth = [date beginningOfMonth];
        _selectedStartDate = beginningOfMonth;
        
        NSMutableArray *indexPaths = @[].mutableCopy;
        
        NSRange dayRange = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:beginningOfMonth];
        
        for (int i = 0; i < dayRange.length; i ++) {
            
            NSDateComponents *dayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:beginningOfMonth];
            dayComponents.day += i;
            
            NSDate *dayDate = [[NSCalendar currentCalendar] dateFromComponents:dayComponents];
            
            NSIndexPath *indexPath = [self indexPathForDate:dayDate];
            
            if (indexPath) {
                [indexPaths addObject:indexPath];
            }
            
            _selectedEndDate = dayDate;
        }
        
        if (self.isViewLoaded) {
            for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
                [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
            }
            for (NSIndexPath *indexPath in indexPaths) {
                [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
    }
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.selectionEnabled;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectWeekCellsForInitialIndexPath:indexPath];
    
    if (self.selectionHandler) {
        self.selectionHandler(self.selectedStartDate, self.selectedEndDate);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePicker:didSelectStartDate:endDate:)]) {
        [self.delegate datePicker:self didSelectStartDate:self.selectedStartDate endDate:self.selectedEndDate];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectionType == SelectionTypeWeek) return NO;
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    ((NXWeekPickerLayout *)self.collectionView.collectionViewLayout).scrolling = YES;
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerDidBeginScrolling:)]) {
        [self.delegate datePickerDidBeginScrolling:self];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        ((NXWeekPickerLayout *)self.collectionView.collectionViewLayout).scrolling = NO;
        [self.collectionView.collectionViewLayout invalidateLayout];
        
        //        [self scrollToVisibleMonth];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerDidEndScrolling:)]) {
            [self.delegate datePickerDidEndScrolling:self];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    ((NXWeekPickerLayout *)self.collectionView.collectionViewLayout).scrolling = NO;
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    //    [self scrollToVisibleMonth];
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePicker:willScrollToBeginningOfMonth:)]) {
        NXWeekPickerLayout *layout = (NXWeekPickerLayout *)self.collectionViewLayout;
        if (layout.scrollingTargetAttributes) {
            NSIndexPath *indexPath = layout.scrollingTargetAttributes.indexPath;
            if (indexPath) {
                NSDate *monthDate = self.monthDates[indexPath.section];
                [self.delegate datePicker:self willScrollToBeginningOfMonth:monthDate];
            }
        }
        
    }
}

- (void)scrollToVisibleMonth
{
    NSIndexPath *firstVisibleIndexPath = self.collectionView.indexPathsForVisibleItems.firstObject;
    NSArray *sectionHeights = ((NXWeekPickerLayout *)self.collectionView.collectionViewLayout).sectionHeights;
    
    CGFloat contentOffsetY = 0.0;
    for (int i = 0; i < firstVisibleIndexPath.section; i++) {
        contentOffsetY += [sectionHeights[i] floatValue];
    }
    
    contentOffsetY -= 10.0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, contentOffsetY) animated:NO];
    });
}

- (void)scrollToVisibleMonthForSection:(NSInteger)section
{
    [self scrollToVisibleMonthForSection:section animated:YES];
}

- (void)scrollToVisibleMonthForSection:(NSInteger)section animated:(BOOL)animated
{
    NSArray *sectionHeights = ((NXWeekPickerLayout *)self.collectionView.collectionViewLayout).sectionHeights;
    
    CGFloat contentOffsetY = 0.0;
    for (int i = 0; i < section; i++) {
        contentOffsetY += [sectionHeights[i] floatValue];
    }
    
    contentOffsetY -= 10.0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, contentOffsetY) animated:animated];
    });
}

#pragma mark - Date Helper Methods

- (NSDate *)dateByAddingMonth:(NSDate *)date
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    dateComponents.month += 1;
    
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

- (NSInteger)visibleDaysInMonth:(NSDate *)date
{
    NSDate *firstDay = [self firstVisibleDayOfMonth:date];
    NSDate *lastDay = [self lastVisibleDayOfMonth:date];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:firstDay toDate:lastDay options:0];
    
    return dateComponents.day;
}

- (NSInteger)daysInMonth:(NSDate *)date
{
    NSDate *firstDay = [date beginningOfMonth];
    NSDate *lastDay = [date endOfMonth];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:firstDay toDate:lastDay options:0];
    
    return dateComponents.day;
}

- (NSDate *)firstVisibleDayOfMonth:(NSDate *)date
{
    date = [date beginningOfMonth];
    
    NSDateComponents *components =
    [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday
                                    fromDate:date];
    
    NSInteger day = -((components.weekday - 1) % DaysInWeek);
    
    date = [date setDay:day];
    date = [date dateByAddingTimeInterval:NX_DAY];
    return date;
}

- (NSInteger)extraDaysAtBegenningOfMonth:(NSDate *)date
{
    date = [date beginningOfMonth];
    
    NSDateComponents *components =
    [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday
                                    fromDate:date];
    
    NSInteger day = ((components.weekday - 1) % DaysInWeek);
    
    return day;
}

- (NSDate *)lastVisibleDayOfMonth:(NSDate *)date
{
    date = [date endOfMonth];
    
    NSDateComponents *components =
    [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday
                                    fromDate:date];
    
    NSInteger day = components.day + (DaysInWeek - 1) - ((components.weekday - 1) % DaysInWeek);
    date = [date setDay:day];
    
    return date;
}

- (BOOL)weekdayIsToday:(NSDate *)date
{
    NSDateComponents *dateComponents =
    [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday
                                    fromDate:date];
    
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday
                                                                        fromDate:[NSDate date]];
    
    return (dateComponents.weekday == todayComponents.weekday);
}

+ (NSDate *)threeMonthsFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingUnit:NSCalendarUnitMonth value:3 toDate:date options:0];
}

+ (NSDate *)threeMonthsToDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingUnit:NSCalendarUnitMonth value:-3 toDate:date options:0];
}

@end
