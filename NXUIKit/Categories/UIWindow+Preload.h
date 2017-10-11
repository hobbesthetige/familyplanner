//
//  UIWindow+Preload.h
//  
//
//  Created by Joseph Sferrazza on 7/7/15.
//
//

#import <UIKit/UIKit.h>

@interface UIWindow (Preload)

/**
 Loads the keyboard by adding a hidden @p UITextField to the window, making it first responder and then removing it.
 
 @see http://stackoverflow.com/a/20436797
 */
- (void)loadKeyboard;
@end
