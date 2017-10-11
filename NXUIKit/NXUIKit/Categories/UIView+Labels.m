//
//  UIView+Labels.m
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 3/13/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "UIView+Labels.h"
@import NXConstraintKit;

static NSUInteger const LabelTag = 901;

@implementation UIView (Labels)

- (void)addCenteredLabelWithText:(NSString *)text textColor:(UIColor *)color {
    [self removeCenteredLabel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 20)];
    label.text = text;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    label.numberOfLines = 0;
    label.tag = LabelTag;
    label.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
    [self addSubview:label];
    
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.greaterThanOrEqualTo(self);
        make.right.greaterThanOrEqualTo(self);
    }];
}

- (void)removeCenteredLabel {
    for (UIView *v in self.subviews) {
        BOOL inside = CGRectContainsPoint(self.frame, v.center);
        if (v.tag == LabelTag && [v isKindOfClass:[UILabel class]] && inside) {
            [v removeFromSuperview];
            break;
        }
    }
}
@end
