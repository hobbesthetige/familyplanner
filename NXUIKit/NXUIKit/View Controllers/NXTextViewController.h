//
//  TextViewController.h
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 3/23/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXTextViewController : UIViewController
@property (nonatomic, assign) BOOL readOnly;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong, readonly) UITextView *textView;

@property (nonatomic, copy) void (^saveBlock)(NSString *newText);
@end
