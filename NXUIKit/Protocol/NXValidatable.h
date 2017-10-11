//
//  NXValidatable.h
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 4/6/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NXValidatable <NSObject>
/** Objects conforming to @p NXValidatable must use this method to report whether or not their content is considered valid. */
- (BOOL)isValid;
@end
