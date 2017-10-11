//
//  NXEditableLabel.m
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 3/17/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXEditableLabel.h"
@import NXConstraintKit;

@interface NXEditableLabel ()
@property (nonatomic, strong, readwrite) UITextField *textField;
@property (nonatomic, copy) NSString *originalText;
@end

@implementation NXEditableLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addHiddenTextField];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addHiddenTextField];
    self.userInteractionEnabled = YES;
}

- (BOOL)becomeFirstResponder {
    if (self.textField.alpha > 0) {
        [self.textField becomeFirstResponder];
        return YES;
    }
    return NO;
}

#pragma mark - Custom Accessors
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    }
    return _textField;
}

#pragma mark - Private
- (void)addHiddenTextField {
    
    self.textField.alpha = 0.0;
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.font = self.font;
    self.textField.textAlignment = self.textAlignment;
    self.textField.backgroundColor = [UIColor clearColor];
    [self addSubview:self.textField];
    
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
}

#pragma mark - Public
- (void)edit {
    self.originalText = self.text;
    self.text = @"";
    self.textField.text = self.originalText;
    self.textField.alpha = 1.0;
    [self layoutIfNeeded]; // Prevents the label from jumping while their values are changed.
}

- (void)saveChanges {
    self.textField.alpha = 0.0;
    self.text = self.textField.text;
    [self.textField resignFirstResponder];
}

- (void)cancelChanges {
    self.textField.alpha = 0.0;
    self.text = self.originalText;
    [self.textField resignFirstResponder];
}
@end
