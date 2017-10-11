//
//  NXTextView.h
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 4/3/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A UITextView that can display placeholder text
 */
@interface NXTextView : UITextView

/** The placeholder text for this UITextView. */
@property (nonatomic, copy) NSString *placeholder;

/** The color of the placeholder text.  By default this is set to a light gray R:196 G:196 B:196. */
@property (nonatomic, strong) UIColor *placeholderTextColor;
@end
