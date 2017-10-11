//
//  NXPercentageCircle.h
//  NXUIKit
//
//  Created by Joe Sferrazza on 6/26/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXPercentageCircle : UIView
@property (nonatomic, assign) IBInspectable CGFloat percentage;
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;
@property (nonatomic, strong) IBInspectable UIColor *completeLineColor;
@property (nonatomic, strong) IBInspectable UIColor *incompleteLineColor;
@property (nonatomic, strong) IBInspectable UIColor *textColor;

- (void)redraw;
@end
