//
//  NXRespondable.h
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 3/12/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <Foundation/Foundation.h>

/** This protocol can be used in lieu of @p -becomeFirstResponder & @p -resignFirstResponder if you want to determine ahead of time if the object will respond. */
@protocol NXRespondable <NSObject>
- (void)respond;

@optional
- (void)resign;
@end
