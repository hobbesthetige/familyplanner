//
//  NXWebViewController.h
//  NXUIKit
//
//  Created by Joe Sferrazza on 9/4/15.
//  Copyright © 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXWebViewController : UIViewController

/* The URL to load when the view appears. */
@property (nonatomic, strong) NSURL *url;

/* Called after the view loads.  Use this to configure the tint colors, fonts, etc.*/
@property (nonatomic, copy) void (^configurationHandler)(UIToolbar *topToolbar, UILabel *titleLabel);

/* Called when the user taps 'Done'. */
@property (nonatomic, copy) void (^doneBlock)();

/* @return A new instance of the web browser. */
+ (instancetype)instantiateFromStoryboard;
@end
