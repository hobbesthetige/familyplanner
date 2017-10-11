//
//  NXWeekPickerLayout.h
//  WeekPicker
//
//  Created by Daniel Meachum on 11/20/14.
//  Copyright (c) 2014 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const KindMonthHeader;
extern NSString * const KindMonthScroll;
extern NSString * const KindLine;
extern NSString * const KindVerticalLine;
extern NSString * const KindDay;

@interface NXWeekPickerLayout : UICollectionViewLayout

@property (assign, nonatomic, getter=isScrolling)   BOOL scrolling;

@property (readonly, nonatomic)     NSArray *sectionHeights;

//Layout attributes that we are anticipating the scrollview to finish scrolling to
@property (readonly, nonatomic)     UICollectionViewLayoutAttributes *scrollingTargetAttributes;

@end
