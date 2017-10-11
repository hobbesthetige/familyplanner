//
//  NXLoadingView.m
//  Schedule Pro
//
//  Created by Joe Sferrazza on 4/14/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXLoadingView.h"
#import "UIFont+System.h"
@import NXConstraintKit;

@interface NXLoadingView ()
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@end

static CGFloat const StandardWidth = 150.0;

@implementation NXLoadingView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        CGFloat oneThirdHeight = CGRectGetHeight(frame) / 3.0;
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 15.0;
        self.layer.masksToBounds = YES;
        
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        effectView.frame = self.bounds;
        [self addSubview:effectView];
        [effectView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self);
        }];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 24.0)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont nx_systemFontOfSize:16.0 weight:NX_UIFontWeightLight];
        _textLabel.numberOfLines = 0;
        _textLabel.minimumScaleFactor = 0.5;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetHeight(self.bounds) - oneThirdHeight);
        _textLabel.textColor = [UIColor whiteColor];
        [self addSubview:_textLabel];
        
        [_textLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bottom).offset(-oneThirdHeight);
            make.centerX.equalTo(self.centerX);
            make.left.greaterThanOrEqualTo(self.left);
        }];
        
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_loadingIndicator setHidesWhenStopped:YES];
        _loadingIndicator.center = CGPointMake(CGRectGetMidX(self.bounds), oneThirdHeight);
        [self addSubview:_loadingIndicator];
        
        [_loadingIndicator makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.top).offset(oneThirdHeight);
        }];
    }
    return self;
}

+ (instancetype)createInView:(UIView *)superview title:(NSString *)title disableInteraction:(BOOL)superviewDisabled {
    NXLoadingView *loadingView = [[NXLoadingView alloc] initWithFrame:CGRectMake(0, 0, StandardWidth, StandardWidth * 0.9)];
    loadingView.textLabel.text = title;
    
    superview.userInteractionEnabled = !superviewDisabled;
    loadingView.center = CGPointMake(CGRectGetMidX(superview.bounds), CGRectGetMidY(superview.bounds));
    [loadingView.loadingIndicator startAnimating];
    loadingView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [superview addSubview:loadingView];
    
    [loadingView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(superview);
        make.height.equalTo(StandardWidth * 0.9);
        make.width.equalTo(StandardWidth);
    }];
    
    [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:0 animations:^{
        loadingView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    } completion:nil];
    
    return loadingView;
}

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
            if (completion) {
                completion();
            }
        }
    }];
}
@end
