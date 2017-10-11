//
//  NXTableViewCell.m
//  SPATCO JT Installation
//
//  Created by Joseph Sferrazza on 2/26/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXTableViewCell.h"

@interface NXTableViewCell()
@end

@implementation NXTableViewCell

#pragma mark - UITableViewCell
- (void)awakeFromNib {
    // Initialization code
    self.hideValueWhileEditing = NO;
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setEditing:(BOOL)editing {
    super.editing = editing;
    
    if (self.hideValueWhileEditing) {
        self.valueLabel.hidden = self.editing;
    }
}

- (void)setBounds:(CGRect)bounds
{
    super.bounds = bounds;
    self.contentView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
    self.valueLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentView.bounds);
    self.valueLabel.adjustsFontSizeToFitWidth = YES;
    self.valueLabel.minimumScaleFactor = 0.7;
}

#pragma mark - NXTableViewCell
+ (CGFloat)preferredHeight {
    return 44.0;
}

#pragma mark - Accessors
- (void)setNumberOfValueLines:(NSUInteger)numberOfValueLines {
    _numberOfValueLines = numberOfValueLines;
    self.valueLabel.numberOfLines = numberOfValueLines;
    [self.valueLabel layoutIfNeeded];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setValue:(NSString *)value {
    _value = value;
    
    self.valueLabel.text = value;
//    [self layoutIfNeeded];
}

@end
