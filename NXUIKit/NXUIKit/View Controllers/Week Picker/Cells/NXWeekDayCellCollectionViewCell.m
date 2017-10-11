//
//  NXWeekDayCellCollectionViewCell.m
//  WeekPicker
//
//  Created by Daniel Meachum on 11/20/14.
//  Copyright (c) 2014 Nexcom. All rights reserved.
//

#import "NXWeekDayCellCollectionViewCell.h"
#import "UIColor+Convenience.h"

void NXContextDrawLine(CGContextRef c, CGPoint start, CGPoint end, CGColorRef color, CGFloat lineWidth) {
    CGContextSetAllowsAntialiasing(c, false);
    CGContextSetStrokeColorWithColor(c, color);
    CGContextSetLineWidth(c, lineWidth);
    CGContextMoveToPoint(c, start.x, start.y - (lineWidth/2.f));
    CGContextAddLineToPoint(c, end.x, end.y - (lineWidth/2.f));
    CGContextStrokePath(c);
    CGContextSetAllowsAntialiasing(c, true);
}

@implementation NXWeekDayCellCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _dateLabel = [UILabel new];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.dateLabel.highlightedTextColor = [UIColor whiteColor];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:self.dateLabel];
        
        _eventsLabel = [UILabel new];
        [self addSubview:self.eventsLabel];
        self.eventsLabel.frame = CGRectMake(0, frame.size.height - 20.0, frame.size.width, 20.0);
        self.eventsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)setDate:(NSDate *)date {
    _date = date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"d";
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    self.dateLabel.text = dateString;
    

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                                 fromDate:[NSDate date]];
    
    BOOL isToday = [date isEqualToDate:[[NSCalendar currentCalendar] dateFromComponents:components]];
    self.currentDate = isToday;
}

- (void)setCurrentDate:(BOOL)currentDate
{
    _currentDate = currentDate;
    
    // Set the backgroundColor here since it's late enough in the loading where the tint color is available
    self.selectedBackgroundView.backgroundColor = self.tintColor;
    
    if (currentDate) {
        self.dateLabel.textColor = self.tintColor;
        self.dateLabel.font = [UIFont boldSystemFontOfSize:self.dateLabel.font.pointSize];
    } else {
        self.dateLabel.textColor = [UIColor blackColor];
        self.dateLabel.font = [UIFont systemFontOfSize:self.dateLabel.font.pointSize];
    }
    
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    
    self.dateLabel.textColor =
    self.enabled ? self.dateLabel.textColor : UIColor.lightGrayColor;
    
    self.backgroundColor =
    self.enabled ? UIColor.whiteColor : [UIColor colorWithRed:.96f green:.96f blue:.96f alpha:1.f];
}
@end
