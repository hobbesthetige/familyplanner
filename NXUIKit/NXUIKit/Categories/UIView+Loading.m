//
//  UIView+Loading.m
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 4/3/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "UIView+Loading.h"
@import NXConstraintKit;

static NSUInteger const LoadingIndicatorTag = 354;
static NSUInteger const NoResultsLabelTag = 498;

@implementation UIView (Loading)
#pragma mark - Public Methods
- (void)showAsLoadedWithResults {
    [self removeViewWithTag:LoadingIndicatorTag ofClass:[UIActivityIndicatorView class]];
    [self removeViewWithTag:NoResultsLabelTag ofClass:[UILabel class]];
    
    if ([self isKindOfClass:[UITableView class]]) {
        ((UITableView *)self).scrollEnabled = YES;
        ((UITableView *)self).separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    else if ([self isKindOfClass:[UICollectionView class]]) {
        ((UICollectionView *)self).scrollEnabled = YES;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)showAsLoadedWithoutResults:(NSString *)message {
    [self removeViewWithTag:LoadingIndicatorTag ofClass:[UIActivityIndicatorView class]];
    [self showNoResultLabelWithMessage:message font:nil];
}

- (void)showAsLoadedWithoutResults:(NSString *)message font:(UIFont *)font {
    [self removeViewWithTag:LoadingIndicatorTag ofClass:[UIActivityIndicatorView class]];
    [self showNoResultLabelWithMessage:message font:font];
}

- (void)showAsLoading {
    if ([self isKindOfClass:[UITableView class]]) {
        ((UITableView *)self).scrollEnabled = NO;
        for (UITableViewCell *cell in ((UITableView *)self).visibleCells) {
            cell.alpha = 0.0;
        }
        ((UITableView *)self).separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else if ([self isKindOfClass:[UICollectionView class]]) {
        ((UICollectionView *)self).scrollEnabled = NO;
        for (UICollectionView *cell in ((UICollectionView *)self).visibleCells) {
            cell.alpha = 0.0;
        }
    }
    else {
        self.alpha = 0.0;
    }
    
    [self removeViewWithTag:LoadingIndicatorTag ofClass:[UIActivityIndicatorView class]];
    [self removeViewWithTag:NoResultsLabelTag ofClass:[UILabel class]];
    
    UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingIndicator.hidesWhenStopped = YES;
    loadingIndicator.center = self.center;
    loadingIndicator.tag = LoadingIndicatorTag;
    
    // If a global appearance has not been set, then use the view's tint color.
    if (![UIActivityIndicatorView appearance].color) {
        loadingIndicator.color = self.tintColor;
    }
    [self.superview addSubview:loadingIndicator];
    [loadingIndicator startAnimating];
    
    [loadingIndicator makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

#pragma mark - Private Methods
- (void)removeViewWithTag:(NSInteger)tag ofClass:(Class)class {
    // Don't break if one is found - there could be multiple.
    for (UIView *v in self.superview.subviews) {
        BOOL inside = CGRectContainsPoint(self.frame, v.center);
        if (v.tag == tag && [v isKindOfClass:class] && inside) {
            [v removeFromSuperview];
        }
    }
}

- (void)showNoResultLabelWithMessage:(NSString *)message font:(UIFont *)font {
    [self showAsLoadedWithoutResults:message font:font textColor:nil];
}

- (void)showAsLoadedWithoutResults:(NSString *)message font:(UIFont *)font textColor:(UIColor *)color {
    UILabel *noResultsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    noResultsLabel.alpha = 0.0;
    noResultsLabel.tag = NoResultsLabelTag;
    noResultsLabel.font = font ?: [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    noResultsLabel.textColor = color ?: [UIColor darkGrayColor];
    noResultsLabel.text = message ?: NSLocalizedString(@"None.", nil);
    noResultsLabel.textAlignment = NSTextAlignmentCenter;
    noResultsLabel.center = self.center;
    noResultsLabel.numberOfLines = 0;
    
    [self removeViewWithTag:LoadingIndicatorTag ofClass:[UIActivityIndicatorView class]];
    
    [self.superview addSubview:noResultsLabel];
    [noResultsLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.greaterThanOrEqualTo(self).offset(10.0);
        make.right.greaterThanOrEqualTo(self).offset(-10.0);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        noResultsLabel.alpha = 1.0;
    }];
}

@end
