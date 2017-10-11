//
//  UIColor+Convenience.h
//  NXHelpers
//
//  Created by Joe Sferrazza on 4/19/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Convenience)
+ (UIColor *)colorWithHexString: (NSString *)hexString;
+ (UIColor *)colorWithRed255:(NSUInteger)red green255:(NSUInteger)green blue255:(NSUInteger)blue;
+ (UIColor *)colorWithRed255:(NSUInteger)red green255:(NSUInteger)green blue255:(NSUInteger)blue alpha:(CGFloat)alpha;
@end
