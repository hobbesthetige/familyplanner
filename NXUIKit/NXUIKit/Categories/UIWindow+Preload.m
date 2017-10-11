//
//  UIWindow+Preload.m
//  
//
//  Created by Joseph Sferrazza on 7/7/15.
//
//

#import "UIWindow+Preload.h"

@implementation UIWindow (Preload)

- (void)loadKeyboard {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.hidden = YES;
    [self addSubview:textField];
    [textField becomeFirstResponder];
    [textField resignFirstResponder];
    [textField removeFromSuperview];
}

@end
