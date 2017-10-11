//
//  UIFont+System.m
//  NXUIKit
//
//  Created by Joseph Sferrazza on 7/6/15.
//  Copyright © 2015 Nexcom. All rights reserved.
//

#import "UIFont+System.h"

const CGFloat NX_UIFontWeightUltraLight = -0.80f;
const CGFloat NX_UIFontWeightThin = -0.60f;
const CGFloat NX_UIFontWeightLight = -0.40f;
const CGFloat NX_UIFontWeightRegular = 0.00f;
const CGFloat NX_UIFontWeightMedium = 0.23f;
const CGFloat NX_UIFontWeightSemibold = 0.30f;
const CGFloat NX_UIFontWeightBold = 0.40f;
const CGFloat NX_UIFontWeightHeavy = 0.56f;
const CGFloat NX_UIFontWeightBlack = 0.62f;

@implementation UIFont (System)

#pragma mark - Public
+ (UIFont *)nx_systemFontOfSize:(CGFloat)size weight:(CGFloat)weight {
    if ([[UIFont class] respondsToSelector:@selector(systemFontOfSize:weight:)]) {
        return [UIFont systemFontOfSize:size weight:weight];
    }
    else {
        return [UIFont fontWithName:[UIFont fontNameForWeight:weight] size:size];
    }
}

#pragma mark - Private
+ (NSString *)fontNameForWeight:(CGFloat)weight {
    // Since we're dealing with floats don't measure against the values directly
    if (weight <= -0.78) {
        return @"HelveticaNeue-UltraLight";
    }
    else if (weight > -0.78 && weight < -0.58) {
        return @"HelveticaNeue-Thin";
    }
    else if (weight > -0.58 && weight < -0.38) {
        return @"HelveticaNeue-Light";
    }
    else if (weight > -0.38 && weight < 0.1) {
        return @"HelveticaNeue";
    }
    else if (weight > 0.1 && weight < 0.38) {
        return @"HelveticaNeue-Medium";
    }
    else if (weight > 0.38) {
        return @"HelveticaNeue-Bold";
    }
    
    // Invalid value so just pass the default
    return @"HelveticaNeue";
}

@end
