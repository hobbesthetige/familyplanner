//
//  NXPhotoCollectionViewCell.h
//  NXMedia
//
//  Created by Joe Sferrazza on 4/3/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const NXPhotoCollectionViewCellIdentifier;
@interface NXPhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, copy) void (^deleteBlock)(UIImage *imageToDelete);
@property (nonatomic, copy) void (^actionBlock)(UIImage *image);
@end
