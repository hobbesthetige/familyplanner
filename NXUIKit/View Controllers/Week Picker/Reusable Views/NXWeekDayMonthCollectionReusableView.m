//
//  NXWeekDayMonthCollectionReusableView.m
//  WeekPicker
//
//  Created by Daniel Meachum on 11/20/14.
//  Copyright (c) 2014 Nexcom. All rights reserved.
//

#import "NXWeekDayMonthCollectionReusableView.h"
@import NXConstraintKit;

@implementation NXWeekDayMonthCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _monthLabel = [UILabel new];
        self.monthLabel.textAlignment = NSTextAlignmentCenter;
        self.monthLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.monthLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.monthLabel];
        
        [self.monthLabel makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
@end

@implementation NXWeekDayMonthScrollCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.monthLabel.font = [UIFont boldSystemFontOfSize:22.0];
    }
    return self;
}

@end