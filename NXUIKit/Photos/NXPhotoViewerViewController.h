//
//  NXPhotoViewerViewController.h
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 4/6/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXPhotoViewerViewController : UIViewController
/**
 @return @p UINavigationController with a @p NXPhotoViewerViewController as it's top view controller.
 */
+ (UINavigationController *)instantiateInNavControllerWithImage:(UIImage *)image;

/**
 @return @p NXPhotoViewerViewController
 */
+ (instancetype)instantiateWithImage:(UIImage *)image;

@property (nonatomic, strong) UIImage *imageToDisplay;

/**
 A block to execute when the user taps the action button.  The action button will automatically be added to this view controller's navigationItem if this block is not nil when the view appears.
 */
@property (nonatomic, copy) void (^actionBlock)(UIImage *image);
@end
