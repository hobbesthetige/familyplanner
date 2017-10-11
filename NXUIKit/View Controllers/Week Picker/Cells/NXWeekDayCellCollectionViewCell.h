//
//  NXWeekDayCellCollectionViewCell.h
//  WeekPicker
//
//  Created by Daniel Meachum on 11/20/14.
//  Copyright (c) 2014 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXWeekDayCellCollectionViewCell : UICollectionViewCell

@property (readonly, nonatomic)     UILabel *dateLabel;
@property (readonly, nonatomic)     UILabel *eventsLabel;

@property (weak, nonatomic)   UIColor    *separatorColor;

@property (assign, nonatomic)   NSInteger weekday;

@property (nonatomic, strong) NSDate *date;
@property (assign, nonatomic, getter=isCurrentDate)   BOOL currentDate;
@property (assign, nonatomic, getter=isEnabled)   BOOL enabled;

@end
