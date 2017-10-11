//
//  UIColor+Convenience.m
//  NXHelpers
//
//  Created by Joe Sferrazza on 4/19/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "UIColor+Convenience.h"

@implementation UIColor (Convenience)

#pragma mark - Hex
+ (CGFloat)colorComponentFrom: (NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)colorWithHexString: (NSString *)hexString {
    NSString *colorString = [hexString stringByReplacingOccurrencesOfString: @"#" withString: @""].uppercaseString;
    CGFloat alpha, red, blue, green;
    switch (colorString.length) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

#pragma mark - RGB
+ (UIColor *)colorWithRed255:(NSUInteger)red green255:(NSUInteger)green blue255:(NSUInteger)blue {
    return [UIColor colorWithRed255:red green255:green blue255:blue alpha:1.0];
}

+ (UIColor *)colorWithRed255:(NSUInteger)red green255:(NSUInteger)green blue255:(NSUInteger)blue alpha:(CGFloat)alpha {
    CGFloat redf = (CGFloat)red;
    CGFloat greenf = (CGFloat)green;
    CGFloat bluef = (CGFloat)blue;
    
    return [UIColor colorWithRed:(redf/255.0) green:(greenf/255.0) blue:(bluef/255.0) alpha:alpha];
}
@end
