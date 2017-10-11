//
//  NXInputAccessoryView.h
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 3/12/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXInputAccessoryView : UIView
/**
 Creates an input accessory view with a previous button, next button and done button.  The buttons are only enabled if their corresponding blocks are non-nil.
 
 @param frame The frame for this view
 @param previousBlk A block to execute when the previous button is tapped.
 @param nextBlk A block to execute when the next button is tapped.
 @param doneBlk A block to execute when the done button is tapped.
 @param tint @p UIColor used to tint all three buttons
 
 @return A new input accessory view
 */
+ (instancetype)viewInFrame:(CGRect)frame previousBlock:(void (^)())previousBlk nextBlock:(void (^)())nextBlk doneBlock:(void (^)())doneBlk tintColor:(UIColor *)tint DEPRECATED_ATTRIBUTE DEPRECATED_MSG_ATTRIBUTE("Use +inputWithPrevious:next:done:tint: or +inputWithDone:tint: instead.");;

/**
 Creates an input accessory view with a previous button, next button and done button.  The buttons are only enabled if their corresponding blocks are non-nil.
 
 @param previousBlk A block to execute when the previous button is tapped.
 @param nextBlk A block to execute when the next button is tapped.
 @param doneBlk A block to execute when the done button is tapped.
 @param tint @p UIColor used to tint all three buttons
 
 @return A new input accessory view
 */
+ (instancetype)inputWithPrevious:(void (^)())previousBlk next:(void (^)())nextBlk done:(void (^)())doneBlk tint:(UIColor *)tint;

/**
 Creates an input accessory view with a previous button, next button and done button.  The buttons are only enabled if their corresponding blocks are non-nil.
 
 @param doneBlk A block to execute when the done button is tapped.
 @param tint @p UIColor used to tint the done button
 
 @return A new input accessory view
 */
+ (instancetype)inputWithDone:(void (^)())doneBlk tint:(UIColor *)tint;

@end
