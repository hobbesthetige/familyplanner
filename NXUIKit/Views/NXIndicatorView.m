//
//  NXIndicatorView.m
//  NXUIKit
//
//  Created by Joseph Sferrazza on 7/6/15.
//  Copyright © 2015 Nexcom. All rights reserved.
//

#import "NXIndicatorView.h"
#import "NXPercentageCircle.h"
#import "UIFont+System.h"
#import <NXUIKit/NXUIKit-Swift.h>

@import NXConstraintKit;

@interface NXIndicatorView ()
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) NXPercentageCircle *percentageCircle;
@property (nonatomic, assign) CGFloat oneThirdHeight;
@property (nonatomic, assign, readwrite) NXIndicatorViewStyle style;
@property (nonatomic, strong) CircleLoadingIndicator *circleIndicator;
@end

static CGFloat const StandardWidth = 150.0;
static CGFloat const SmallWidth = 100.0;

@implementation NXIndicatorView

#pragma mark - Initializers
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = CGRectGetWidth(frame) * 0.15;
        self.layer.masksToBounds = YES;

        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        effectView.frame = self.bounds;
        [self addSubview:effectView];
        [effectView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self);
        }];
    }
    return self;
}

+ (nonnull instancetype)showIndicatorWithStyle:(NXIndicatorViewStyle)style superview:(nonnull UIView *)superview disableInteraction:(BOOL)superviewDisabled {
    return [NXIndicatorView showIndicatorWithStyle:style superview:superview title:nil disableInteraction:superviewDisabled];
}

+ (instancetype)showIndicatorWithStyle:(NXIndicatorViewStyle)style superview:(nonnull UIView *)superview title:(nullable NSString *)title disableInteraction:(BOOL)superviewDisabled {
    
    CGFloat width = [self styleIsSmall:style] ? SmallWidth : StandardWidth;
    NXIndicatorView *activityView = [[NXIndicatorView alloc] initWithFrame:CGRectMake(0, 0, width, width * 0.9)];
    
    activityView.style = style;
    
    switch (style) {
        case NXIndicatorViewStyleActivity:
        case NXIndicatorViewStyleActivitySmall:
        {
            activityView.textLabel.text = title ?: NSLocalizedString(@"Loading", nil);
            [activityView addSubview:activityView.loadingIndicator];
            
            [activityView.loadingIndicator makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(activityView);
                make.centerY.equalTo(activityView.top).offset(activityView.oneThirdHeight);
            }];
            [activityView.loadingIndicator startAnimating];
        }
            break;
        case NXIndicatorViewStylePercentage:
        case NXIndicatorViewStylePercentageSmall: {
            [activityView addSubview:activityView.percentageCircle];
            
            [activityView.percentageCircle makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(activityView);
                make.height.width.equalTo(activityView.oneThirdHeight * 2.0);
            }];
            break;
        }
        case NXIndicatorViewStyleSpinning:
        case NXIndicatorViewStyleSpinningSmall:{
            activityView.textLabel.text = title ?: NSLocalizedString(@"Loading", nil);
            [activityView addSubview:activityView.circleIndicator];
            
            CGFloat size = style == NXIndicatorViewStyleSpinningSmall ? 28.0 : 60.0;
            CGFloat thickness = style == NXIndicatorViewStyleSpinningSmall ? 1.5 : 4.0;
            activityView.circleIndicator.thickness = thickness;
            [activityView.circleIndicator makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(activityView);
                make.centerY.equalTo(activityView.top).offset(activityView.oneThirdHeight);
                make.height.width.equalTo(size);
            }];
            break;
        }
        default:
            NSAssert(NO, @"Unexpected NXIndicatorViewStyle");
            break;
    }
    
    superview.userInteractionEnabled = !superviewDisabled;
    [activityView showAndAddToSuperview:superview];
    
    return activityView;
}

#pragma mark - Custom Accessors
- (CircleLoadingIndicator *)circleIndicator {
    if (!_circleIndicator) {
        _circleIndicator = [[CircleLoadingIndicator alloc] initWithFrame:CGRectMake(0.0, 0.0, 48.0, 48.0)];
        _circleIndicator.center = CGPointMake(CGRectGetMidX(self.bounds), self.oneThirdHeight);
    }
    return _circleIndicator;
}

- (UIActivityIndicatorView *)loadingIndicator {
    if (!_loadingIndicator) {
        
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_loadingIndicator setHidesWhenStopped:YES];
        _loadingIndicator.center = CGPointMake(CGRectGetMidX(self.bounds), self.oneThirdHeight);
    }
    return _loadingIndicator;
}

- (CGFloat)oneThirdHeight {
    return CGRectGetHeight(self.frame) / 3.0;
}

- (NXPercentageCircle *)percentageCircle {
    if (!_percentageCircle) {
        _percentageCircle = [[NXPercentageCircle alloc] initWithFrame:self.bounds];
        _percentageCircle.completeLineColor = [UIColor whiteColor];
        _percentageCircle.incompleteLineColor = [UIColor colorWithWhite:0.93 alpha:0.2];
        _percentageCircle.lineWidth = 7.0;
        _percentageCircle.textColor = [UIColor whiteColor];
        _percentageCircle.backgroundColor = [UIColor clearColor];
    }
    return _percentageCircle;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 24.0)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont nx_systemFontOfSize:15.0 weight:NX_UIFontWeightLight];
        _textLabel.numberOfLines = 0;
        _textLabel.minimumScaleFactor = 0.5;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetHeight(self.bounds) - self.oneThirdHeight);
        _textLabel.textColor = [UIColor whiteColor];
        [self addSubview:_textLabel];
        
        [_textLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bottom).offset(-self.oneThirdHeight + 6.0);
            make.centerX.equalTo(self.centerX);
            make.left.greaterThanOrEqualTo(self.left);
        }];
    }
    return _textLabel;
}

- (void)setContentColor:(UIColor * __nullable)contentColor {
    if (!contentColor) {
        contentColor = [UIColor whiteColor];
    }
    _contentColor = contentColor;
    
    switch (self.style) {
        case NXIndicatorViewStylePercentage:
            self.percentageCircle.completeLineColor = contentColor;
            self.percentageCircle.textColor = contentColor;
            break;
        case NXIndicatorViewStyleActivity:
            self.loadingIndicator.color = contentColor;
            self.textLabel.textColor = contentColor;
            break;
        case NXIndicatorViewStyleSpinning:
        case NXIndicatorViewStyleSpinningSmall:
            self.circleIndicator.color = contentColor;
            self.textLabel.textColor = contentColor;
            break;
        default:
            break;
    }
}

#pragma mark - Public Instance Methods
- (void)hide {
    [self hideWithCompletion:nil];
}

- (void)hideWithCompletion:(void (^)())completion {
    if (!self.superview) {
        if (completion) {
            completion();
        }
        return;
    }
    self.superview.userInteractionEnabled = YES;
    
    // Enlarge the view slightly then quickly fade it out
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.25, 1.25);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.25 animations:^{
                self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                self.alpha = 0.25;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                self.alpha = 1.0;
                self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                if (completion) {
                    completion();
                }
            }];
        }
        else {
            [self removeFromSuperview];
            if (completion) {
                completion();
            }
        }
    }];
}

- (void)updatePercentage:(CGFloat)percentage {
    if (self.style == NXIndicatorViewStylePercentage || self.style == NXIndicatorViewStylePercentageSmall) {
        self.percentageCircle.percentage = percentage;
    }
}

#pragma mark - Private Class Methods
+ (BOOL)styleIsSmall:(NXIndicatorViewStyle)style {
    return style == NXIndicatorViewStyleActivitySmall || style == NXIndicatorViewStylePercentageSmall || style == NXIndicatorViewStyleSpinningSmall;
}

#pragma mark - Private Instance Methods
- (void)showAndAddToSuperview:(UIView *)superview {
    self.center = CGPointMake(CGRectGetMidX(superview.bounds), CGRectGetMidY(superview.bounds));
    
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [superview addSubview:self];
    
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(superview);
        make.height.equalTo(CGRectGetWidth(self.bounds) * 0.9);
        make.width.equalTo(CGRectGetWidth(self.bounds));
    }];
    
    [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:0 animations:^{
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    } completion:nil];
}

@end
