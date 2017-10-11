//
//  NXTextView.m
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 4/3/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXTextView.h"
@import NXConstraintKit;

@interface NXTextView ()
@property (nonatomic, strong) UILabel *placeholderLabel;
@end

@implementation NXTextView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initialize];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

#pragma mark - Custom Accessors
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
    _placeholderTextColor = placeholderTextColor;
    self.placeholderLabel.textColor = placeholderTextColor;
}

#pragma mark - Private
- (void)initialize {
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.textContainerInset.left, self.textContainerInset.top, CGRectGetWidth(self.frame), self.font.pointSize)];
    self.placeholderLabel.font = self.font;
    // Set the placeholder text and color if they've been set
    self.placeholderLabel.textColor = self.placeholderTextColor ?: [UIColor colorWithWhite:0.77 alpha:1.0];
    self.placeholderLabel.text = self.placeholder ?: @"";
    self.placeholderLabel.numberOfLines = 0;
    
    [self addSubview:self.placeholderLabel];
    
    [self.placeholderLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(self.textContainerInset.top);
        make.left.equalTo(self).offset(5.0);
        make.right.equalTo(self).offset(-self.textContainerInset.right);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:self];
}

- (void)setText:(NSString *)text {
    super.text = text;
    
    // Update the visibility of the placeholder when the text is set.
    [self textChanged];
}

- (void)textChanged {
//    // If the textbox only contains whitespace, clear it out.
//    // This prevents the user from starting with a return but they shouldn't need to.
//    if ([self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
//        self.text = @"";
//    }
    self.placeholderLabel.hidden = self.text.length != 0;
}

#pragma mark - UITextView Methods
- (void)setFont:(UIFont *)font {
    super.font = font;
    
    self.placeholderLabel.font = font;
}

#pragma mark - NSObject
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
