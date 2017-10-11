//
//  TextFieldTableViewCell.m
//  SPATCO JT Installation
//
//  Created by Joe Sferrazza on 3/9/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXTextFieldTableViewCell.h"

@interface NXTextFieldTableViewCell () <UITextFieldDelegate>

@end

@implementation NXTextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    
    [self.textField becomeFirstResponder];
    return YES;
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    
    [self.textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)field {
    if (self.editBlock) {
        self.editBlock(field.text);
    }
}

- (void)setValue:(NSString *)value {
    super.value = value;
    
    self.textField.text = value;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - NXRespondableCell
- (void)resign {
    [self.textField resignFirstResponder];
}

- (void)respond {
    [self.textField becomeFirstResponder];
}
@end
