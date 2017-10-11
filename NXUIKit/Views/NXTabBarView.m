//
//  NXTabBarView.m
//  NXUIKit
//
//  Created by Joe Sferrazza on 8/14/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXTabBarView.h"


@import NXConstraintKit;
#import <NXUIKit/UIFont+System.h>

@interface NXTabBarView ()
@property (nonatomic, strong) UIView *selectionBar;
@property (nonatomic, strong) NSMutableArray *tabs;
@end

static CGFloat const SelectionBarRestingWidthMultiplier = 0.65;
static CGFloat const SelectionBarRestingHeight = 2.0;
static CGFloat const SelectionBarCenterInset = 1.5;
static CGFloat const SelectionBarSideInset = 8.0;

@implementation NXTabBarView
@synthesize tabFont = _tabFont;

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initialize];
}

- (void)initialize {
    self.clipsToBounds = NO;
    [self addSelectionBar];
    
    // Set the defaults
    self.selectedIndex = 0;
    self.useSpringAnimation = NO;
}

#pragma mark - Custom Accessors
- (UIFont *)tabFont {
    if (!_tabFont) {
        _tabFont = [UIFont nx_systemFontOfSize:14.0 weight:NX_UIFontWeightLight];
    }
    return _tabFont;
}

- (NSMutableArray *)tabs {
    if (!_tabs) {
        _tabs = [[NSMutableArray alloc] initWithCapacity:self.tabNames.count];
    }
    return _tabs;
}

- (void)setTabFont:(UIFont *)tabFont {
    _tabFont = tabFont;
    
    for (UIButton *button in self.tabs) {
        [button.titleLabel setFont:tabFont];
    }
}

- (void)setTabBackgroundColor:(UIColor *)tabBackgroundColor
{
    _tabBackgroundColor = tabBackgroundColor;
    
    self.backgroundColor = tabBackgroundColor;
}

- (void)setEdgeLineColor:(UIColor *)edgeLineColor
{
    _edgeLineColor = edgeLineColor;
    
    [self setNeedsDisplay];
}

- (void)setUnselectedTabTextColor:(UIColor *)unselectedTabTextColor
{
    _unselectedTabTextColor = unselectedTabTextColor;
    
    [self setUpTabs];
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    
    self.selectionBar.backgroundColor = tintColor;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [self selectIndex:selectedIndex fromIndex:self.selectedIndex];
    
    _selectedIndex = selectedIndex;
}

- (void)setPosition:(UIBarPosition)position {
    _position = position;
    
    [self setNeedsDisplay];
}

- (void)setTabNames:(NSArray *)tabNames {
    _tabNames = tabNames;
    [self setUpTabs];
    
    // Resize the selection bar for the new tabs
    [self.selectionBar remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([self.tabs firstObject]).multipliedBy(SelectionBarRestingWidthMultiplier);
        make.height.equalTo(SelectionBarRestingHeight);
        make.centerX.equalTo([self.tabs objectAtIndex:self.selectedIndex]);
        make.centerY.equalTo(self.bottom).offset(-SelectionBarCenterInset);
    }];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow.tintColor) {
        self.selectionBar.backgroundColor = newWindow.tintColor;
    }
}

#pragma mark - Private
- (void)addSelectionBar {
    self.selectionBar = [[UIView alloc] init];
    [self addSubview:self.selectionBar];
    [self.selectionBar makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50);
        make.height.equalTo(SelectionBarRestingHeight);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.bottom).offset(-SelectionBarCenterInset);
    }];
    self.selectionBar.backgroundColor = self.tintColor;
    
}

- (void)buttonWasTapped:(UIButton *)sender {
    [self.tabs enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        if ([btn isEqual:sender]) {
            self.selectedIndex = idx;
            *stop = YES;
        }
    }];
}

- (void)centerSelectionBarOnIndex:(NSUInteger)newIndex fromIndex:(NSUInteger)oldIndex {
    if (newIndex == oldIndex) {
        [self.selectionBar remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo([self.tabs objectAtIndex:newIndex]).multipliedBy(0.9);
            make.height.equalTo(SelectionBarRestingHeight * 0.5);
            make.centerX.equalTo([self.tabs objectAtIndex:newIndex]);
            make.centerY.equalTo(self.bottom).offset(-SelectionBarCenterInset);
        }];
        
        [self setNeedsLayout];
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:0 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.selectionBar remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo([self.tabs objectAtIndex:newIndex]).multipliedBy(SelectionBarRestingWidthMultiplier);
                make.height.equalTo(SelectionBarRestingHeight);
                make.centerX.equalTo([self.tabs objectAtIndex:self.selectedIndex]);
                make.centerY.equalTo(self.bottom).offset(-SelectionBarCenterInset);
            }];
            [self setNeedsLayout];
            [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:0 animations:^{
                [self layoutIfNeeded];
            } completion:nil];
        }];
    }
    else {
        BOOL movingRight = newIndex > oldIndex;
        
        if (self.useSpringAnimation) {
            [self.selectionBar remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo([self.tabs firstObject]).multipliedBy(0.2);
                make.height.equalTo(SelectionBarRestingHeight * 2.0);
                
                if (movingRight) {
                    make.left.equalTo([self.tabs objectAtIndex:oldIndex]).offset(SelectionBarSideInset);
                }
                else {
                    make.right.equalTo([self.tabs objectAtIndex:oldIndex]).offset(-SelectionBarSideInset);
                }
                make.bottom.equalTo(self);
            }];
            
            [self setNeedsLayout];
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                [self.selectionBar remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo([self.tabs firstObject]).multipliedBy(SelectionBarRestingWidthMultiplier);
                    make.height.equalTo(SelectionBarRestingHeight);
                    make.centerX.equalTo([self.tabs objectAtIndex:newIndex]);
                    make.bottom.equalTo(self);
                }];
                [self setNeedsLayout];
                [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.75 initialSpringVelocity:0.0 options:0 animations:^{
                    [self layoutIfNeeded];
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }
        else {
            [self.selectionBar remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo([self.tabs firstObject]).multipliedBy(SelectionBarRestingWidthMultiplier);
                make.height.equalTo(SelectionBarRestingHeight);
                make.centerX.equalTo([self.tabs objectAtIndex:newIndex]);
                make.bottom.equalTo(self);
            }];
            [self setNeedsLayout];
            [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.75 initialSpringVelocity:0.0 options:0 animations:^{
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

- (void)setUpTabs {
    [self.tabNames enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:name forState:UIControlStateNormal];
        [button.titleLabel setFont:self.tabFont];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.minimumScaleFactor = 0.5;
        [button addTarget:self action:@selector(buttonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:button atIndex:0];
        
        if (idx != self.selectedIndex) {
            button.tintColor = self.unselectedTabTextColor ?: [UIColor lightGrayColor];
        }
        [button remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self);
            make.top.equalTo(self);
            if (idx == 0) {
                make.leading.equalTo(self);
                if (self.tabNames.count == 1) {
                    make.trailing.equalTo(self);
                }
            }
            else {
                make.width.equalTo([self.tabs firstObject]);
                make.leading.equalTo(((UIView *)[self.tabs lastObject]).trailing).offset(4.0);
                
                if (idx == self.tabNames.count - 1) {
                    make.trailing.equalTo(self);
                }
            }
        }];
        [self.tabs addObject:button];
    }];
}

- (void)selectIndex:(NSUInteger)index fromIndex:(NSUInteger)oldIndex {
    if (index >= self.tabs.count) {
        return;
    }
    
    NSString __block *selectedTitle = nil;
    NSInteger __block selectedIndex = -1;
    [self.tabs enumerateObjectsUsingBlock:^(UIButton *tab, NSUInteger idx, BOOL *stop) {
        if (idx == index) {
            tab.tintColor = self.tintColor;
            selectedTitle = [tab titleForState:UIControlStateNormal];
            selectedIndex = idx;
        }
        else {
            tab.tintColor = self.unselectedTabTextColor?:[UIColor lightGrayColor];
        }
    }];
    [self centerSelectionBarOnIndex:selectedIndex fromIndex:oldIndex];
    
    [self.delegate tabView:self selectedTabTitled:selectedTitle atIndex:selectedIndex];
}

#pragma mark - UIView
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.position == UIBarPositionAny) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat lineWidth = 0.5;
    CGFloat yLocation = 0.0;
    
    if (self.position == UIBarPositionTop || self.position == UIBarPositionTopAttached) {
        yLocation = CGRectGetHeight(self.frame) - (lineWidth / 2.0);
    }
    else if (self.position == UIBarPositionBottom) {
        yLocation = lineWidth / 2.0;
    }
    
    CGContextSetStrokeColorWithColor(context, self.edgeLineColor ? self.edgeLineColor.CGColor : [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(context, lineWidth);
    
    CGContextMoveToPoint(context, 0.0, yLocation);
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), yLocation);
    
    CGContextStrokePath(context);
}


@end
