//
//  NXWeekDayHeaderCollectionReusableView.m
//  WeekPicker
//
//  Created by Daniel Meachum on 11/20/14.
//  Copyright (c) 2014 Nexcom. All rights reserved.
//

#import "NXWeekDayHeaderCollectionReusableView.h"
#import "UIColor+Convenience.h"
@import NXConstraintKit;

@interface NXWeekDayHeaderCollectionReusableView ()

@property (strong, nonatomic)   UIView    *titleBackground;

@end
@implementation NXWeekDayHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleBackground = [[UIView alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, frame.size.width, frame.size.height), 12.0, 5.0)];
        self.titleBackground.layer.cornerRadius = nearbyintf(frame.size.height / 3.0);
        [self addSubview:self.titleBackground];
        
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        self.dayLabel.backgroundColor = [UIColor clearColor];
        self.dayLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(122.0/255.0) blue:(255.0/255.0) alpha:1.0];
        self.dayLabel.font = [UIFont systemFontOfSize:12.0];
        
        [self addSubview:self.dayLabel];
        
        [self.dayLabel makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.titleBackground makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.equalTo(self.dayLabel).offset(-4.0);
            make.width.equalTo(30);
        }];
    }
    return self;
}

@end
