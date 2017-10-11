//
//  NXTabItem.m
//  SPATCO JT Installation
//
//  Created by Nexcom on 2/20/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXTabItem.h"

@interface NXTabItem()
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy) void (^action)();
@end

@implementation NXTabItem

#pragma mark - Initializers
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

+ (instancetype)tabItemWithTitle:(NSString *)title action:(void (^)())actionBlock {
    NXTabItem *item = [[NXTabItem alloc] init];
    item.title = title;
    item.action = actionBlock;
    return item;
}

#pragma mark - Public Instance Methods
- (void)performAction {
    if (self.action) {
        self.action();
    }
}
@end
