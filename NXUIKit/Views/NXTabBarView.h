//
//  NXTabBarView.h
//  NXUIKit
//
//  Created by Joe Sferrazza on 8/14/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NXTabBarView;

@protocol NXTabBarViewDelegate <NSObject>
- (void)tabView:(NXTabBarView *)view selectedTabTitled:(NSString *)title atIndex:(NSUInteger)index;
@end

@interface NXTabBarView : UIView

//Note: Use tint color for selected tab text color and selection line color

@property (nonatomic, copy) NSArray *tabNames;
@property (nonatomic, assign) UIBarPosition position;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) UIFont *tabFont;
@property (nonatomic, strong) UIColor *tabBackgroundColor;
@property (nonatomic, strong)   UIColor    *edgeLineColor;
@property (nonatomic, strong)   UIColor    *unselectedTabTextColor;

/** Whether or not to use a spring animation when the tab bar index changes.  @p NO by default.  */
@property (nonatomic, assign) BOOL useSpringAnimation;
@property (nonatomic, weak) id<NXTabBarViewDelegate> delegate;
@end
