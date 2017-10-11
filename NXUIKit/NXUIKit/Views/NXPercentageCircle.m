//
//  NXPercentageCircle.m
//  NXUIKit
//
//  Created by Joe Sferrazza on 6/26/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXPercentageCircle.h"

@interface NXPercentageCircle ()
@property (nonatomic, strong) UIBezierPath *filledArc;
@property (nonatomic, strong) UIBezierPath *unfilledArc;
@property (nonatomic, strong, readwrite) UILabel *percentageLabel;
@end

@implementation NXPercentageCircle
@synthesize textColor = _textColor, completeLineColor = _completeLineColor, incompleteLineColor = _incompleteLineColor;

#pragma mark - Accessors - Getters
- (CGFloat)lineWidth {
    if (!_lineWidth) {
        _lineWidth = 25.0;
    }
    return _lineWidth;
}

- (UIColor *)completeLineColor {
    if (!_completeLineColor) {
        _completeLineColor = [UIColor blackColor];
    }
    return _completeLineColor;
}

- (UIColor *)incompleteLineColor {
    if (!_incompleteLineColor) {
        _incompleteLineColor = [UIColor colorWithWhite:0.93 alpha:1.0];
    }
    return _incompleteLineColor;
}

- (UILabel *)percentageLabel {
    if (!_percentageLabel) {
        _percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10.0, 10.0)];
        _percentageLabel.textAlignment = NSTextAlignmentCenter;
        _percentageLabel.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
        _percentageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_percentageLabel];
        
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:_percentageLabel
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0 constant:0.0];
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_percentageLabel
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0 constant:0.0];
        [self addConstraints:@[centerX, centerY]];
        [_percentageLabel sizeToFit];
    }
    
    return _percentageLabel;
}

- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}

#pragma mark - Accessors - Setters
- (void)setCompleteLineColor:(UIColor *)completeLineColor {
    _completeLineColor = completeLineColor;
    [self setNeedsDisplay];
}

- (void)setIncompleteLineColor:(UIColor *)incompleteLineColor {
    _incompleteLineColor = incompleteLineColor;
    [self setNeedsDisplay];
}

- (void)setPercentage:(CGFloat)percentage {
    _percentage = percentage;
    
    self.percentageLabel.text = [NSString stringWithFormat:@"%.0f%%", (percentage * 100.0)];
    [self generatePaths];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    self.percentageLabel.textColor = textColor;
}

#pragma mark - Public
- (void)redraw {
    [self generatePaths];
}

#pragma mark - Private
- (void)generatePaths {
    CGFloat maxDiameter = 0.0;
    if (CGRectGetWidth(self.bounds) < CGRectGetHeight(self.bounds)) {
        maxDiameter = CGRectGetWidth(self.bounds);
    }
    else {
        maxDiameter = CGRectGetHeight(self.bounds);
    }
    
    CGFloat arcRadius = (maxDiameter / 2.0) - (self.lineWidth / 2.0);
    CGFloat startingAngleRadians = -((M_PI * 90) / 180);
    
    CGFloat filledAngleDegrees = 360.0 * self.percentage;
    CGFloat filledAngleRadians = startingAngleRadians + ((M_PI * filledAngleDegrees) / 180);
    
    
    self.filledArc = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0) radius:arcRadius startAngle:startingAngleRadians endAngle:filledAngleRadians clockwise:YES];
    self.filledArc.lineCapStyle = kCGLineCapRound;
    self.filledArc.lineWidth = self.lineWidth;
    
    self.unfilledArc = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0) radius:arcRadius startAngle:filledAngleRadians endAngle:startingAngleRadians clockwise:YES];
    self.unfilledArc.lineCapStyle = kCGLineCapSquare;
    self.unfilledArc.lineWidth = self.lineWidth;
    
    [self setNeedsDisplay];
}

#pragma mark - UIView
- (void)drawRect:(CGRect)rect {
    [self.incompleteLineColor setStroke];
    [self.unfilledArc stroke];
    
    [self.completeLineColor setStroke];
    [self.filledArc stroke];
    
    self.percentageLabel.font = [UIFont boldSystemFontOfSize:CGRectGetWidth(self.bounds) * 0.25];
}

@end
