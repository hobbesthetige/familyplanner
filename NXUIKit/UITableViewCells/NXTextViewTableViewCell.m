//
//  TextViewTableViewCell.m
//  SPATCO JT Installation
//
//  Created by Joe Sferrazza on 3/9/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXTextViewTableViewCell.h"
#import "NXInputAccessoryView.h"

@interface NXTextViewTableViewCell() <UITextViewDelegate>

@end

@implementation NXTextViewTableViewCell

#pragma mark - UITableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    
    [self.textView becomeFirstResponder];
    return YES;
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    
    [self.textView resignFirstResponder];
    
    return YES;
}

#pragma mark - NXTableViewCell
+ (CGFloat)preferredHeight {
    return 150.0;
}

#pragma mark - Custom Accessors
- (void)setValue:(NSString *)value {
    super.value = value;
    
    self.textView.text = value;
    
    if (self.textView.text.length > 0) {
        [self.textView scrollRangeToVisible:NSMakeRange(0, 1)];
    }
}

#pragma mark - Public
- (void)showInputAccessoryWithPreviousBlock:(void (^)())previousBlock nextBlock:(void (^)())nextBlock {
    typeof(self) __weak weakSelf = self;
    self.textView.inputAccessoryView = [NXInputAccessoryView inputWithPrevious:previousBlock next:nextBlock done:^{
        [weakSelf.textView resignFirstResponder];
    } tint:self.tintColor];
    self.textView.inputAccessoryView.tintColor = self.tintColor;
}

#pragma mark - NXRespondableCell
- (void)resign {
    [self.textView resignFirstResponder];
}

- (void)respond {
    [self.textView becomeFirstResponder];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (self.editBlock) {
        self.editBlock(textView.text);
    }
}

//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    [textView setScrollEnabled:YES];
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView {
//    [textView setScrollEnabled:NO];
//}

@end
