//
//  NXWeekPickerLayout.m
//  WeekPicker
//
//  Created by Daniel Meachum on 11/20/14.
//  Copyright (c) 2014 Nexcom. All rights reserved.
//

#import "NXWeekPickerLayout.h"

NSString * const KindMonthHeader = @"KindMonthHeader";
NSString * const KindMonthScroll = @"KindMonthScroll";
NSString * const KindLine = @"KindLine";
NSString * const KindVerticalLine = @"KindVerticalLine";
NSString * const KindDay = @"KindDay";

@interface NXWeekPickerLayout ()

@property (strong, nonatomic)   NSMutableDictionary    *itemAttributes;
@property (strong, nonatomic)   NSMutableDictionary    *weekDayHeaderAttributes;
@property (strong, nonatomic)   NSMutableDictionary    *monthHeaderAttributes;
@property (strong, nonatomic)   NSMutableDictionary    *monthScrollAttributes;
@property (strong, nonatomic)   NSMutableDictionary    *dayLineAttributes;
@property (strong, nonatomic)   NSMutableDictionary    *weekLineAttributes;

@property (assign, nonatomic)   CGFloat floatingY;
@property (assign, nonatomic)   CGFloat lineSize;

@end
@implementation NXWeekPickerLayout

static NSInteger const DaysInWeek = 7;
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.itemAttributes = @{}.mutableCopy;
    self.weekDayHeaderAttributes = @{}.mutableCopy;
    self.monthHeaderAttributes = @{}.mutableCopy;
    self.monthScrollAttributes = @{}.mutableCopy;
    self.dayLineAttributes = @{}.mutableCopy;
    self.weekLineAttributes = @{}.mutableCopy;
    
    self.lineSize = 1.f / [UIScreen mainScreen].scale;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    NSArray *array =
    [self layoutAttributesForElementsInRect:({
        CGRect bounds = self.collectionView.bounds;
        bounds.origin.y = proposedContentOffset.y - self.collectionView.bounds.size.height/2.f;
        bounds.size.width *= 1.5f;
        bounds;
    })];
    
    CGFloat minOffsetY = CGFLOAT_MAX;
    UICollectionViewLayoutAttributes *targetLayoutAttributes = nil;
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in array) {
        if ([layoutAttributes.representedElementKind isEqualToString:KindMonthScroll]) {
            CGFloat offsetY = fabs(layoutAttributes.frame.origin.y - proposedContentOffset.y);
            
            if (offsetY < minOffsetY) {
                minOffsetY = offsetY;
                
                targetLayoutAttributes = layoutAttributes;
            }
        }
    }
    
    _scrollingTargetAttributes = targetLayoutAttributes;
    
    if (targetLayoutAttributes) {
        return targetLayoutAttributes.frame.origin;
    }
    
    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y);
}

- (void)prepareLayout
{
    [self.itemAttributes removeAllObjects];
    [self.weekDayHeaderAttributes removeAllObjects];
    [self.monthHeaderAttributes removeAllObjects];
    [self.dayLineAttributes removeAllObjects];
    [self.weekLineAttributes removeAllObjects];
    [self.monthScrollAttributes removeAllObjects];
    
    const CGFloat width      = self.collectionView.bounds.size.width;
//    const CGFloat padding = 20.0;
    self.floatingY = 0.0;
    
    NSMutableArray *sectionHeights = @[].mutableCopy;
    
    [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)] enumerateIndexesUsingBlock:^(NSUInteger sectionIndex, BOOL *stop) {
        
        __block CGFloat sectionHeight = 0.0;
        
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
        
        //
        //  Month Header
        //
        UICollectionViewLayoutAttributes *monthHeaderAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:KindMonthHeader withIndexPath:sectionIndexPath];
        
        monthHeaderAttributes.frame = CGRectMake(0, self.floatingY, width, 20.0);
        monthHeaderAttributes.zIndex = 100;
        
        self.monthHeaderAttributes[sectionIndexPath] = monthHeaderAttributes;
        
        self.floatingY += CGRectGetHeight(monthHeaderAttributes.frame) + 30.0;
        sectionHeight += CGRectGetHeight(monthHeaderAttributes.frame) + 30.0;
        
        //
        //  Month Header Horizontal Line
        //
        UICollectionViewLayoutAttributes *monthHeaderLineAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:KindLine withIndexPath:sectionIndexPath];
        
        monthHeaderLineAttributes.frame = CGRectMake(0, self.floatingY, width, self.lineSize);
        monthHeaderLineAttributes.zIndex = 9999;
        
        self.weekLineAttributes[sectionIndexPath] = monthHeaderLineAttributes;
        
        __block CGFloat floatingX = 0;
        
        [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.collectionView numberOfItemsInSection:sectionIndex])] enumerateIndexesUsingBlock:^(NSUInteger itemIndex, BOOL *stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
            
            NSUInteger weekday = indexPath.item % DaysInWeek ;
            
            CGFloat itemWidth  = roundf(width / DaysInWeek );
            CGFloat itemHeight = itemWidth;
            
            if (weekday == DaysInWeek  - 1) {
                itemWidth = width - (itemWidth * (DaysInWeek  - 1));
            }
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            itemAttributes.frame = CGRectMake(floatingX, self.floatingY, itemWidth, itemHeight);
            
            self.itemAttributes[indexPath] = itemAttributes;
            
            if (weekday == DaysInWeek - 1) {
                floatingX = 0;
                self.floatingY += itemHeight;
                sectionHeight += itemHeight;
                
                //
                //  Week Header Horizontal Line
                //
                UICollectionViewLayoutAttributes *monthHeaderLineAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:KindLine withIndexPath:indexPath];
                
                monthHeaderLineAttributes.frame = CGRectMake(0, self.floatingY, width, self.lineSize);
                monthHeaderLineAttributes.zIndex = 9999;
                
                self.weekLineAttributes[indexPath] = monthHeaderLineAttributes;
            } else {
                floatingX += itemWidth;
            }
            
            
        }];
        
        floatingX = 0.0;
        [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, DaysInWeek + 1)] enumerateIndexesUsingBlock:^(NSUInteger itemIndex, BOOL *stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
            
            CGFloat itemWidth  = roundf(width / DaysInWeek );
            floatingX = (itemWidth * itemIndex);
            
            //
            //  Day Attributes
            //
            UICollectionViewLayoutAttributes *dayAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:KindDay withIndexPath:indexPath];
            
            dayAttributes.frame = CGRectMake(floatingX - itemWidth, CGRectGetMaxY(monthHeaderAttributes.frame), itemWidth, 30.0);
            dayAttributes.zIndex = 200;
            
            self.weekDayHeaderAttributes[indexPath] = dayAttributes;
            
            
            if (itemIndex > 0) {
                //
                //  Day Vertical Line
                //
                UICollectionViewLayoutAttributes *dayLineAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:KindVerticalLine withIndexPath:indexPath];
                
                dayLineAttributes.frame = CGRectMake(floatingX, CGRectGetMaxY(dayAttributes.frame), self.lineSize, self.floatingY - CGRectGetMaxY(dayAttributes.frame));
                dayLineAttributes.zIndex = 9999;
                
                self.dayLineAttributes[indexPath] = dayLineAttributes;
            }
            
            
            
        }];
        
        CGFloat const footerPadding = CGRectGetHeight(self.collectionView.frame) - sectionHeight;
        
        self.floatingY += footerPadding;
        sectionHeight += footerPadding;
        [sectionHeights addObject:@(sectionHeight)];
        
    }];
    
    _sectionHeights = sectionHeights;
    
    if (self.isScrolling) {
        __block CGFloat floatingY = 0.0;
        [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)] enumerateIndexesUsingBlock:^(NSUInteger sectionIndex, BOOL *stop) {
            CGFloat sectionHeight = [sectionHeights[sectionIndex] floatValue];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
            
            UICollectionViewLayoutAttributes *scrollingAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:KindMonthScroll withIndexPath:indexPath];
            
            scrollingAttributes.frame = CGRectMake(0, floatingY, width, sectionHeight);
            scrollingAttributes.zIndex = CGFLOAT_MAX;
            
            self.monthScrollAttributes[indexPath] = scrollingAttributes;
            
            floatingY += sectionHeight;
        }];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemAttributes[indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if ([elementKind isEqualToString:KindMonthHeader]) {
        return self.monthHeaderAttributes[indexPath];
    } else if ([elementKind isEqualToString:KindLine]) {
        return self.weekLineAttributes[indexPath];
    } else if ([elementKind isEqualToString:KindVerticalLine]) {
        return self.dayLineAttributes[indexPath];
    } else if ([elementKind isEqualToString:KindDay]) {
        return self.weekDayHeaderAttributes[indexPath];
    } else if ([elementKind isEqualToString:KindMonthScroll]) {
        return self.monthScrollAttributes[indexPath];
    }
    
    return nil;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, self.floatingY);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *collections = @[self.itemAttributes, self.monthHeaderAttributes, self.weekDayHeaderAttributes, self.dayLineAttributes, self.weekLineAttributes, self.monthScrollAttributes];
    
    NSMutableArray *results = @[].mutableCopy;
    for (NSDictionary *collection in collections) {
        [collection enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *stop) {
            CGRect frame = attributes.frame;
            if (CGRectIntersectsRect(frame, rect)) {
                [results addObject:attributes];
            }
        }];
    }
    
    return results;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
