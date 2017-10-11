//
//  PhotoManager.h
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 3/13/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

@import UIKit;

@class NXPhotoManager;
@protocol NXPhotoManagerDelegate <NSObject>
- (void)photoManager:(NXPhotoManager *)manager finishedWithImages:(NSArray *)images takenOn:(NSDate *)date;
@optional
- (void)photoManager:(NXPhotoManager *)manager didShowImagePickerUsingCamera:(BOOL)camera;
- (void)photoManager:(NXPhotoManager *)manager didCancelImagePickerUsingCamera:(BOOL)camera;
@end

@interface NXPhotoManager : NSObject
@property (nonatomic, assign) UIImagePickerControllerSourceType currentSourceType;

/**
 Whether or not to allow the user to select multiple photos at a time.  @NO by default.
 */
@property (nonatomic, assign) BOOL useMultiPhotoPicker;

/**
 Whether or not to optimize the photo by reducing it's size and quality.  This can drastically reduce the filesize.
 YES by default.
 */
@property (nonatomic, assign) BOOL shouldOptimizePhotos;

/**
 Whether or not to allow the user to crop the photo after it is selected.
 NO by default.
 */
@property (nonatomic, assign) BOOL shouldAllowEditingPhotos;

/**
 Whether or not the photo manager attempts to read the photo's date taken after it is selected.  This requires access to the user's photos.
 NO by default.
 */
@property (nonatomic, assign) BOOL shouldReturnPhotoDate;

@property (nonatomic, weak) id <NXPhotoManagerDelegate> delegate;

// Initializers
/** Designated initializer */
- (instancetype)initInViewController:(UIViewController *)controller;

- (void)selectPhoto;
- (void)showActionSheetFromItem:(UIBarButtonItem *)item;
- (void)showActionSheetWithTitle:(NSString *)title item:(UIBarButtonItem *)item;
- (void)showActionSheetWithTitle:(NSString *)title fromFrame:(CGRect)frame inView:(UIView *)view;
- (void)takePhoto;
@end
