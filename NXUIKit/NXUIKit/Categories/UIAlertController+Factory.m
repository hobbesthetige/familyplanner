//
//  UIAlertController+Factory.m
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 4/24/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "UIAlertController+Factory.h"

@implementation UIAlertController (Factory)

+ (instancetype)alertFromError:(NSError *)error {
    return [UIAlertController alertFromError:error title:error.localizedDescription];
}

+ (instancetype)alertFromError:(NSError *)error title:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:error.localizedRecoverySuggestion preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    
    return alert;
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message {
    return [UIAlertController alertWithTitle:title message:message action:nil];
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message action:(void (^)())actionBlock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (actionBlock) {
            actionBlock();
        }
    }]];
    
    return alert;
}

@end
