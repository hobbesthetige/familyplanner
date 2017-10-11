//
//  NXBadgeView.m
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 3/12/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXBadgeView.h"

@import NXConstraintKit;

@interface NXBadgeView()
@property (nonatomic, strong) UILabel *badgeValueLabel;
@end

@implementation NXBadgeView

@synthesize fontSize = _fontSize, cornerRadius = _cornerRadius;
#pragma mark - UIView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = self.tintColor;
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.masksToBounds = YES;
    
    self.badgeValueLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.badgeValueLabel.font = [UIFont boldSystemFontOfSize:self.fontSize];
    self.badgeValueLabel.textAlignment = NSTextAlignmentCenter;
    self.badgeValueLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:self.badgeValueLabel];
    [self.badgeValueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self updateLabelValue];
}

#pragma mark - Custom Accessors
- (CGFloat)cornerRadius {
    if (!_cornerRadius) {
        return CGRectGetHeight(self.bounds) / 2.0;
    }
    return _cornerRadius;
}

- (CGFloat)fontSize {
    if (!_fontSize) {
        return 13.0;
    }
    return _fontSize;
}

- (void)setBadgeNumber:(NSUInteger)badgeNumber {
    _badgeNumber = badgeNumber;
    
    [self updateLabelValue];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    self.badgeValueLabel.font = [UIFont boldSystemFontOfSize:fontSize];
}

#pragma mark - Private
- (void)updateLabelValue {
    self.badgeValueLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.badgeNumber];
}

@end
