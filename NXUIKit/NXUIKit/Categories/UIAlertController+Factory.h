//
//  UIAlertController+Factory.h
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 4/24/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Factory)
/** Creates a new instance with a single 'OK' button using the specified error and the @p UIAlertControllerStyleAlert style.
 
 @param error The error to use in the alert message & title.  The error's @p localizedDescription property is used for the title and the @p localizedRecoverySuggestion is used for the alert's message.  */
+ (instancetype)alertFromError:(NSError *)error;

/** Creates a new instance with a single 'OK' button using the specified error, title and the @p UIAlertControllerStyleAlert style.
 
 @param error The error to use in the alert message.  The error's @p localizedRecoverySuggestion is used for the alert's message.  
 @param title The alert's title.
 */
+ (instancetype)alertFromError:(NSError *)error title:(NSString *)title;

/** Creates a new instance with a single 'OK' button using the @p UIAlertControllerStyleAlert style. */
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message;

/** Creates a new instance with a single 'OK' button using the @p UIAlertControllerStyleAlert style. Executes the specified block when 'OK' is tapped. */
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message action:(void (^)())actionBlock;
@end
