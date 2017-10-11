//
//  NXWeekDayHeaderCollectionReusableView.h
//  WeekPicker
//
//  Created by Daniel Meachum on 11/20/14.
//  Copyright (c) 2014 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXWeekDayHeaderCollectionReusableView : UICollectionReusableView

@property (readonly, nonatomic)     UILabel *dayLabel;

@property (assign, nonatomic, getter=isCurrentDate)   BOOL currentDate;

@end
