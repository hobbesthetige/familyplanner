//
//  NXInputAccessoryView.m
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 3/12/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXInputAccessoryView.h"

@import NXConstraintKit;

@interface NXInputAccessoryView()
@property (nonatomic, copy) void (^nextBlock)();
@property (nonatomic, copy) void (^prevBlock)();
@property (nonatomic, copy) void (^doneBlock)();

@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *prevButton;
@property (nonatomic, strong) UIButton *doneButton;
@end

static CGFloat const StandardButtonEdgeDimension = 44.0;
static CGFloat const StandardSpacing = 10.0;

@implementation NXInputAccessoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.94 alpha:0.95];
        
        UIView *decoration = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 1.0)];
        decoration.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        [self addSubview:decoration];
        
        [decoration makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(1.0);
        }];
        UIImage *backImage = [UIImage imageNamed:@"nxuikit_icon_back_25" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        self.prevButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.prevButton.frame = CGRectMake(StandardSpacing, 0, StandardButtonEdgeDimension, StandardButtonEdgeDimension);
        [self.prevButton setImage:backImage forState:UIControlStateNormal];
        [self.prevButton addTarget:self action:@selector(previousWasTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.prevButton];
        
        [self.prevButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(StandardSpacing);
            make.centerY.equalTo(self);
            make.width.height.equalTo(StandardButtonEdgeDimension);
        }];
        
        UIImage *nextImage = [UIImage imageNamed:@"nxuikit_icon_forward_25" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.nextButton.frame = CGRectMake(StandardButtonEdgeDimension + (StandardSpacing * 2), 0, StandardButtonEdgeDimension, StandardButtonEdgeDimension);
        [self.nextButton setImage:nextImage forState:UIControlStateNormal];
        [self.nextButton addTarget:self action:@selector(nextWasTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nextButton];
        
        [self.nextButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.prevButton.right).offset(StandardSpacing);
            make.centerY.equalTo(self);
            make.width.height.equalTo(StandardButtonEdgeDimension);
        }];
        
        
        self.doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.doneButton.frame = CGRectMake(CGRectGetWidth(frame) - StandardButtonEdgeDimension - StandardSpacing, 0, StandardButtonEdgeDimension, StandardButtonEdgeDimension);
        [self.doneButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
        [self.doneButton addTarget:self action:@selector(doneWasTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.doneButton];
        
        [self.doneButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-StandardSpacing);
            make.centerY.equalTo(self);
            make.height.equalTo(StandardButtonEdgeDimension);
        }];
    }
    return self;
}

+ (instancetype)viewInFrame:(CGRect)frame previousBlock:(void (^)())previousBlk nextBlock:(void (^)())nextBlk doneBlock:(void (^)())doneBlk tintColor:(UIColor *)tint {
    NXInputAccessoryView *view = [[NXInputAccessoryView alloc] initWithFrame:frame];
    view.nextBlock = nextBlk;
    view.prevBlock = previousBlk;
    view.doneBlock = doneBlk;
    
    view.nextButton.alpha = view.nextBlock ? 1.0 : 0.2;
    view.prevButton.alpha = view.prevBlock ? 1.0 : 0.2;
    view.doneButton.alpha = view.doneBlock ? 1.0 : 0.2;
    view.nextButton.userInteractionEnabled = view.nextBlock ? YES : NO;
    view.prevButton.userInteractionEnabled = view.prevBlock ? YES : NO;
    view.doneButton.userInteractionEnabled = view.doneBlock ? YES : NO;
    
    if (tint) {
        view.prevButton.tintColor = tint;
        view.nextButton.tintColor = tint;
        view.doneButton.tintColor = tint;
    }
    
    return view;
}

+ (instancetype)inputWithPrevious:(void (^)())previousBlk next:(void (^)())nextBlk done:(void (^)())doneBlk tint:(UIColor *)tint {
    CGRect frame = CGRectMake(0.0, 0.0, 0.0, 44.0);
    NXInputAccessoryView *view = [[NXInputAccessoryView alloc] initWithFrame:frame];
    view.nextBlock = nextBlk;
    view.prevBlock = previousBlk;
    view.doneBlock = doneBlk;
    
    view.nextButton.alpha = view.nextBlock ? 1.0 : 0.2;
    view.prevButton.alpha = view.prevBlock ? 1.0 : 0.2;
    view.doneButton.alpha = view.doneBlock ? 1.0 : 0.2;
    view.nextButton.userInteractionEnabled = view.nextBlock ? YES : NO;
    view.prevButton.userInteractionEnabled = view.prevBlock ? YES : NO;
    view.doneButton.userInteractionEnabled = view.doneBlock ? YES : NO;
    
    if (tint) {
        view.prevButton.tintColor = tint;
        view.nextButton.tintColor = tint;
        view.doneButton.tintColor = tint;
    }
    
    return view;

}

+ (instancetype)inputWithDone:(void (^)())doneBlk tint:(UIColor *)tint{
    CGRect frame = CGRectMake(0.0, 0.0, 0.0, 44.0);
    NXInputAccessoryView *view = [[NXInputAccessoryView alloc] initWithFrame:frame];
    
    view.doneBlock = doneBlk;
    
    view.nextButton.alpha = 0.0;
    view.prevButton.alpha = 0.0;
    view.doneButton.alpha = view.doneBlock ? 1.0 : 0.2;
    view.doneButton.userInteractionEnabled = view.doneBlock ? YES : NO;
    
    if (tint) {
        view.doneButton.tintColor = tint;
    }
    
    return view;

}
#pragma mark - Actions
- (void)doneWasTapped {
    if (self.doneBlock) {
        self.doneBlock();
    }
}

- (void)nextWasTapped {
    if (self.nextBlock) {
        self.nextBlock();
    }
}

- (void)previousWasTapped {
    if (self.prevBlock) {
        self.prevBlock();
    }
}
@end
