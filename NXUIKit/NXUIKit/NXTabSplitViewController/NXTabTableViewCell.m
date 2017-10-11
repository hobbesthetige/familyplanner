//
//  NXTabTableViewCell.m
//  SPATCO JT Installation
//
//  Created by Nexcom on 2/20/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXTabTableViewCell.h"
#import "NXTabItem.h"

#import "UIFont+System.h"

@interface NXTabTableViewCell ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *tabImageView;
@end

@implementation NXTabTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    [super awakeFromNib];
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.layer.shadowOpacity = 0.0;
    self.layer.shadowRadius = 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.titleLabel.textColor = [UIColor colorWithRed:0.0 green:0.35 blue:0.6 alpha:1.0];
        self.titleLabel.font = [UIFont nx_systemFontOfSize:15.0 weight:NX_UIFontWeightMedium];
        self.tabImageView.alpha = 1.0;
        self.layer.shadowOpacity = 0.75;
        self.layer.zPosition = 1;
        (self.tabImageView).image = [UIImage imageNamed:@"tab"];
    }
    else {
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.layer.zPosition = 0;
        self.layer.shadowOpacity = 0.0;
        self.titleLabel.font = [UIFont nx_systemFontOfSize:15.0 weight:NX_UIFontWeightLight];
        (self.tabImageView).image = [UIImage imageNamed:@"tab_disabled"];
    }
}

- (void)setItem:(NXTabItem *)item {
    _item = item;
    
    self.titleLabel.text = item.title;

}
@end
