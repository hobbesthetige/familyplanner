//
//  PhotoManager.m
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 3/13/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXPhotoManager.h"
#import "UIImage+Optimize.h"
#import <NXUIKit/NXUIKit-Swift.h>

@import AssetsLibrary;
@import AVFoundation;
@import ImageIO;

@interface NXPhotoManager() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, weak) UIViewController *viewController;
@end

@implementation NXPhotoManager
#pragma mark - Initializers
- (instancetype)initInViewController:(UIViewController *)controller {
    if (self = [super init]) {
        _viewController = controller;
        _useMultiPhotoPicker = NO;
        _shouldOptimizePhotos = YES;
        _shouldAllowEditingPhotos = NO;
        _shouldReturnPhotoDate = NO;
    }
    return self;
}

#pragma mark - Private
- (void)promptUserToAllowCameraAccess {
    NSString *appName = [[NSBundle mainBundle].infoDictionary objectForKey:(NSString *)kCFBundleNameKey];
    UIAlertController *settingsAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:NSLocalizedString(@"You've denied %@ access to the camera.", nil), appName] message:NSLocalizedString(@"You can grant access by tapping Settings.", nil) preferredStyle:UIAlertControllerStyleAlert];
    [settingsAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Do nothing
    }]];
    
    if ([NXUIKitManager defaultManager].openSettingsHandler) {
        [settingsAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [NXUIKitManager defaultManager].openSettingsHandler();
        }]];
    }
    [self.viewController presentViewController:settingsAlert animated:YES completion:nil];
}

#pragma mark - Public
- (void)selectPhoto {
    [self showImagePickerAndTakePhoto:NO];
}

- (void)showActionSheetFromItem:(UIBarButtonItem *)item {
    [self showActionSheetWithTitle:@"Attach a Photo" item:item];
}

- (void)showActionSheetWithTitle:(NSString *)title item:(UIBarButtonItem *)item {
    typeof(self) __weak weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Photo Library", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (weakSelf.useMultiPhotoPicker) {
            [weakSelf showMultiPhotoPicker];
        }
        else {
            [weakSelf showImagePickerAndTakePhoto:NO];
        }
    }]];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Take Photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakSelf showImagePickerAndTakePhoto:YES];
        }]];
    }
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    // Pass the tint color
    alertController.view.tintColor = self.viewController.view.tintColor;
    alertController.popoverPresentationController.barButtonItem = item;

    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)showActionSheetWithTitle:(NSString *)title fromFrame:(CGRect)frame inView:(UIView *)view {
    typeof(self) __weak weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Photo Library", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (weakSelf.useMultiPhotoPicker) {
            [weakSelf showMultiPhotoPicker];
        }
        else {
            [weakSelf showImagePickerAndTakePhoto:NO];
        }
    }]];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Take Photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakSelf showImagePickerAndTakePhoto:YES];
        }]];
    }
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    alertController.popoverPresentationController.sourceRect = frame;
    alertController.popoverPresentationController.sourceView = view;
    // Pass the tint color
    alertController.view.tintColor = self.viewController.view.tintColor;
    
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)showMultiPhotoPicker {
    NXMultiPhotoPicker *picker = [[NXMultiPhotoPicker alloc] init];
    picker.options.targetPhotoSize = CGSizeMake(1000.0, 1000.0);
    picker.options.targetPreviewCellLength = 100.0;
    picker.options.allowTakingPhotos = NO;
    typeof(self) __weak weakSelf = self;
    picker.options.completion = ^(NSArray<UIImage *> * _Nonnull images) {
        [weakSelf.delegate photoManager:weakSelf finishedWithImages:images takenOn:nil];
    };
    [self.viewController presentViewController:picker animated:YES completion:nil];
}

-(void)showImagePickerAndTakePhoto:(BOOL)takePhoto {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = self.shouldAllowEditingPhotos;
    
    if (self.viewController.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        picker.modalPresentationStyle = UIModalPresentationPageSheet;
    }
    
    if(takePhoto && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.currentSourceType = picker.sourceType;
        // Only present the picker if the user provided access to the camera.
        // If they denied access, ask them to change it
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusAuthorized || status == AVAuthorizationStatusNotDetermined) {
            [self.viewController presentViewController:picker animated:YES completion:nil];
        }
        else if (status == AVAuthorizationStatusDenied || AVAuthorizationStatusRestricted) {
            [self promptUserToAllowCameraAccess];
        }
    }
    else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.currentSourceType = picker.sourceType;
        [self.viewController presentViewController:picker animated:YES completion:nil];
    }
}

- (void)takePhoto {
    [self showImagePickerAndTakePhoto:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([self.delegate respondsToSelector:@selector(photoManager:didCancelImagePickerUsingCamera:)]) {
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            [self.delegate photoManager:self didCancelImagePickerUsingCamera:YES];
        }
        else {
            [self.delegate photoManager:self didCancelImagePickerUsingCamera:NO];
        }
    }
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Make sure the status bar remains white
    // If the user is prompted for permission our first attempt to revert the status bar style might not have worked
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *pictureImage = nil;
    
    if (!self.shouldAllowEditingPhotos) {
        if (![info objectForKey:UIImagePickerControllerOriginalImage]) {
            return;
        }
        
        pictureImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (self.shouldOptimizePhotos) {
            pictureImage = [pictureImage rotateAndScale];
        }
    }
    else if (self.shouldAllowEditingPhotos) {
        if (![info objectForKey:UIImagePickerControllerEditedImage]) {
            return;
        }
        pictureImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if (self.shouldOptimizePhotos) {
            pictureImage = [pictureImage rotateAndScale];
        }
    }
    
    if (self.shouldReturnPhotoDate) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL]
                 resultBlock:^(ALAsset *asset) {
                     
                     ALAssetRepresentation *image_representation = [asset defaultRepresentation];
                     
                     // create a buffer to hold image data
                     uint8_t *buffer = (Byte*)malloc((unsigned long)image_representation.size);
                     NSUInteger length = [image_representation getBytes:buffer fromOffset: 0.0  length:(unsigned int)image_representation.size error:nil];
                     
                     if (length != 0)  {
                         
                         // buffer -> NSData object; free buffer afterwards
                         NSData *adata = [[NSData alloc] initWithBytesNoCopy:buffer length:(unsigned int)image_representation.size freeWhenDone:YES];
                         
                         // identify image type (jpeg, png, RAW file, ...) using UTI hint
                         NSDictionary* sourceOptionsDict = [NSDictionary dictionaryWithObjectsAndKeys:(id)[image_representation UTI] ,kCGImageSourceTypeIdentifierHint,nil];
                         
                         // create CGImageSource with NSData
                         CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef) adata,  (__bridge CFDictionaryRef) sourceOptionsDict);
                         
                         // get imagePropertiesDictionary
                         CFDictionaryRef imagePropertiesDictionary;
                         imagePropertiesDictionary = CGImageSourceCopyPropertiesAtIndex(sourceRef,0, NULL);
                         
                         // get exif data
                         CFDictionaryRef exif = (CFDictionaryRef)CFDictionaryGetValue(imagePropertiesDictionary, kCGImagePropertyExifDictionary);
                         NSDictionary *exif_dict = (__bridge NSDictionary*)exif;
                         
                         if ([exif_dict objectForKey:@"DateTimeOriginal"]) {
                             NSString *dateString = [exif_dict objectForKey:@"DateTimeOriginal"];
                             
                             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                             [formatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
                             NSDate *date = [formatter dateFromString:dateString];
                             [self.delegate photoManager:self finishedWithImages:@[pictureImage] takenOn:date];
                         }
                         else {
                             [self.delegate photoManager:self finishedWithImages:@[pictureImage] takenOn:nil];
                         }
                         CFRelease(imagePropertiesDictionary);
                         CFRelease(sourceRef);
                     }
                     else {
                         [self.delegate photoManager:self finishedWithImages:@[pictureImage] takenOn:nil];
                     }
                 }
                failureBlock:^(NSError *error) {
                    [self.delegate photoManager:self finishedWithImages:@[pictureImage] takenOn:nil];
                    NSLog(@"couldn't get asset: %@", error);
                }
         ];
    }
    else {
        [self.delegate photoManager:self finishedWithImages:@[pictureImage] takenOn:nil];
    }
}
@end
