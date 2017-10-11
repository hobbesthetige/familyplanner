//
//  UIImage+Optimize.h
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 3/13/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Optimize)
/**
 Rotates the image based on it's @p UIImageOrientation and scales it to a max resolution of 1000 pixels using a compression ratio of 0.75.
 */
- (UIImage *)rotateAndScale;

/**
 Rotates the image based on it's @p UIImageOrientation and scales it to the specified resolution using a compression ratio of 0.75.
 */
- (UIImage *)rotateAndScaleLargestSideTo:(NSUInteger)maxResolution;

/**
 Rotates the image based on it's @p UIImageOrientation and scales it to the specified resolution and compression ratio.
 */
- (UIImage *)rotateAndScaleLargestSideTo:(NSUInteger)maxResolution compression:(CGFloat)compression;
@end
