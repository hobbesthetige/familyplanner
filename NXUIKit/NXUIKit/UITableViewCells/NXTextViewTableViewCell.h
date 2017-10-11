//
//  TextViewTableViewCell.h
//  SPATCO JT Installation
//
//  Created by Joe Sferrazza on 3/9/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXTableViewCell.h"
#import "NXRespondable.h"

@interface NXTextViewTableViewCell : NXTableViewCell <NXRespondable>
@property (nonatomic, weak) IBOutlet UITextView *textView;

- (void)showInputAccessoryWithPreviousBlock:(void (^)())previousBlock nextBlock:(void (^)())nextBlock;
@end
