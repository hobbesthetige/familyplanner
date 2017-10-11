//
//  NXListItemProtocol.h
//  NXUIKit
//
//  Created by Joe Sferrazza on 4/15/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;

@protocol NXListItemProtocol <NSObject>
- (NSString *)listTitle;

@optional
- (NSString *)listValue;
- (UIImage *)listImage;
@end
