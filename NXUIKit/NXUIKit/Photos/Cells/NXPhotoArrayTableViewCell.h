//
//  NXPhotoArrayTableViewCell.h
//  NXMedia
//
//  Created by Joe Sferrazza on 4/3/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const NXPhotoArrayTableViewCellIdentifier;

@interface NXPhotoArrayTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray *photos; // Strong not copy so changes outside this class are reflected here as well
+ (instancetype)dequeueCell;
@property (nonatomic, copy) void (^enlargeBlock)(UIImage *image);

@property (nonatomic, copy) void (^deleteBlock)(UIImage *image);
@end
