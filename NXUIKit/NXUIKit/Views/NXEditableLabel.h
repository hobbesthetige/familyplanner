//
//  NXEditableLabel.h
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 3/17/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

/** A UILabel that cen be edited by calling @p -edit.  When editing, the label is replaced with a borderless text field. Set the textfield text color by calling [UITextField appearanceWhenContainedInInstancesOfClasses:@[[NXEditableLabel class]]].textColor */
@interface NXEditableLabel : UILabel

/** The textfield that is displayed while editing this label.  Use this property to adjust the capitalization mode, keyboard type, placeholder, etc. */
@property (nonatomic, strong, readonly) UITextField *textField;

/**
 Tells the label to enter edit mode and replace the label with a borderless @p UITextField.
 */
- (void)edit;

/**
 Commits changes from the text field to the label.
 */
- (void)saveChanges;

/**
 Undos any changes and reverts text back to the original value.
 */
- (void)cancelChanges;
@end
