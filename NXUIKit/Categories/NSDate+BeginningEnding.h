//
//  NSDate+BeginningEnding.h
//  ServByte
//
//  Created by Daniel Meachum on 7/14/14.
//  Copyright (c) 2014 Nexcom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (BeginningEnding)
///---------------------------------------
/// @name Calculate Beginning / End of Day
///---------------------------------------

/**
 
 */
- (NSDate *)beginningOfDay;

/**
 
 */
- (NSDate *)endOfDay;

///----------------------------------------
/// @name Calculate Beginning / End of Week
///----------------------------------------

/**
 
 */
- (NSDate *)beginningOfWeek;

/**
 
 */
- (NSDate *)endOfWeek;

///-----------------------------------------
/// @name Calculate Beginning / End of Month
///-----------------------------------------

/**
 
 */
- (NSDate *)beginningOfMonth;

/**
 
 */
- (NSDate *)endOfMonth;

///----------------------------------------
/// @name Calculate Beginning / End of Year
///----------------------------------------

/**
 
 */
- (NSDate *)beginningOfYear;

/**
 
 */
- (NSDate *)endOfYear;

- (NSDate *)setDay:(NSInteger)day;

@end
