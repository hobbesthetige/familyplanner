//
//  NXWeekDayMonthCollectionReusableView.h
//  WeekPicker
//
//  Created by Daniel Meachum on 11/20/14.
//  Copyright (c) 2014 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXWeekDayMonthCollectionReusableView : UICollectionReusableView

@property (readonly, nonatomic)     UILabel *monthLabel;

@end

@interface NXWeekDayMonthScrollCollectionReusableView : NXWeekDayMonthCollectionReusableView

@end
