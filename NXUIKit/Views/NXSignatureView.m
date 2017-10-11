//
//  NXSignatureView.m
//  SPATCO JT Installation
//
//  Created by Joe Sferrazza on 3/2/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXSignatureView.h"

@import NXConstraintKit;

@interface NXSignatureView()
@property (nonatomic, strong) UILabel *signatureLineLabel;
@property (nonatomic, strong) UIView *signatureLine;
@property (nonatomic, strong) UIImageView *signatureImageView;

@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, strong) NSMutableArray *subPaths;
@property (nonatomic, strong) UIBezierPath *previousPath;
@property (nonatomic, assign) CGPoint previousPoint;

@end

static CGFloat const PenWidthMaximumChange = 0.35;

@implementation NXSignatureView {
    CGPoint points[5];
    NSUInteger pointIndex;
}

#pragma mark - UIView
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        // Make the view non-editable by default and show the signature line.
        _editable = NO;
        _shouldHideSignatureLine = NO;
        _signatureLineText = @"";
        
        self.multipleTouchEnabled = NO;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat labelInset = 4.0;
    
    self.signatureLineLabel = [UILabel new];
    self.signatureLineLabel.text = self.signatureLineText;
    self.signatureLineLabel.numberOfLines = 0;
    self.signatureLineLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    [self addSubview:self.signatureLineLabel];
    [self.signatureLineLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(labelInset);
        make.right.equalTo(self).offset(-labelInset);
        make.bottom.equalTo(self).offset(-labelInset);
    }];
    self.signatureLineLabel.hidden = self.shouldHideSignatureLine;
    
    self.signatureLine = [UIView new];
    self.signatureLine.backgroundColor = [UIColor blackColor];
    [self addSubview:self.signatureLine];
    [self.signatureLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.signatureLineLabel.top).offset(-labelInset);
        make.height.equalTo(1.0);
    }];
    self.signatureLine.hidden = self.shouldHideSignatureLine;
    
    self.paths = [[NSMutableArray alloc] initWithCapacity:1];
}

- (void)drawRect:(CGRect)rect {
    // Stroke the current path the user is drawing as well as each previous path
    for (UIBezierPath *p in self.subPaths) {
        [p stroke];
    }
    for (NSMutableArray *subPath in self.paths) {
        for (UIBezierPath *p in subPath) {
            [p stroke];
        }
    }
}

#pragma mark - Custom Accessors - Getters
- (BOOL)userHasSigned {
    return self.paths.count > 0;
}

- (UIImage *)image {
    
    // If the user passes a static image, send it back.
    // Avoid the getter to prevent unnecessarily instantiating the image view.
    if (_signatureImageView.image) {
        return self.signatureImageView.image;
    }
    // Hide the line & label
    [self.signatureLine setHidden:YES];
    [self.signatureLineLabel setHidden:YES];
    
    // Capture the background color so we can set it back
    // Use a clear background while capturing
    UIColor *backgroundColor = self.backgroundColor;
    self.backgroundColor = [UIColor clearColor];
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *signatureImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Unhide the line & label
    (self.signatureLine).hidden = self.shouldHideSignatureLine;
    (self.signatureLineLabel).hidden = self.shouldHideSignatureLine;
    
    // Restore the background color
    self.backgroundColor = backgroundColor;
    
    return signatureImage;
}

- (CGFloat)maximumPenWidth {
    if (!_maximumPenWidth) {
        _maximumPenWidth = 0.5;
    }
    return _maximumPenWidth;
}

- (CGFloat)minimumPenWidth {
    if (!_minimumPenWidth) {
        _minimumPenWidth = 4.0;
    }
    return _minimumPenWidth;
}

- (UIImageView *)signatureImageView {
    if (!_signatureImageView) {
        _signatureImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _signatureImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _signatureImageView;
}

#pragma mark - Custom Accessors - Setters
- (void)setEditable:(BOOL)editable {
    _editable = editable;
    
    self.userInteractionEnabled = editable;
    self.backgroundColor = editable ? [UIColor colorWithWhite:0.96 alpha:1.0] : [UIColor whiteColor];
}

- (void)setShouldHideSignatureLine:(BOOL)shouldHideSignatureLine {
    _shouldHideSignatureLine = shouldHideSignatureLine;
    self.signatureLine.hidden = shouldHideSignatureLine;
    self.signatureLineLabel.hidden = shouldHideSignatureLine;
}

- (void)setSignatureLineText:(NSString *)signatureLineText {
    _signatureLineText = signatureLineText;
    self.signatureLineLabel.text = signatureLineText;
}

#pragma mark - Public Methods
- (void)clear {
    self.subPaths = nil;
    self.paths = [[NSMutableArray alloc] initWithCapacity:1];
    [self setNeedsDisplay];
    
    [self.delegate signatureChangedInView:self];
}

- (void)displaySignatureImage:(UIImage *)image {
    if (image) {
        self.editable = NO;
        
        self.signatureImageView.image = image;
        
        if (!self.signatureImageView.superview) {
            [self addSubview:self.signatureImageView];
            [self.signatureImageView makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
    }
    else {
        self.editable = YES;
        self.signatureImageView.image = nil;
        [self.signatureImageView removeFromSuperview];
        self.signatureImageView = nil;
    }
}

- (void)undo {
    [self.paths removeLastObject];
    [self setNeedsDisplay];
    
    [self.delegate signatureChangedInView:self];
}

#pragma mark - Private Methods
- (CGPoint)pointFromTouches:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}

#pragma mark - Touch Events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.subPaths = [[NSMutableArray alloc] initWithCapacity:20];
    pointIndex = 0;
    points[0] = self.previousPoint = [self pointFromTouches:touches];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didBeginSigningInView:)]) {
        
        [self.delegate didBeginSigningInView:self];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGFloat maxY = CGRectGetMinY(self.signatureLine.frame);
    
    CGPoint currentPoint = [self pointFromTouches:touches];
    currentPoint = CGPointMake(currentPoint.x, MIN(maxY, currentPoint.y));
    
    CGFloat distance = hypotf(self.previousPoint.x - currentPoint.x, self.previousPoint.y - currentPoint.y);
    self.previousPoint = currentPoint;
    
    CGFloat width = MAX(self.minimumPenWidth, MIN(20.0 / distance, self.maximumPenWidth));
    CGFloat previousWidth = !self.previousPath ? self.maximumPenWidth : self.previousPath.lineWidth;
    
    // Prevent the width from changing more then the specified maximum for a smoother transition
    if (width > previousWidth) {
        width = MIN(width, previousWidth + PenWidthMaximumChange);
    }
    else {
        width = MAX(width, previousWidth - PenWidthMaximumChange);
    }
    
    //    NSLog(@"Distance: %.2f - Width: %.2f", distance, width);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = width;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineCapStyle = kCGLineCapRound;
    
    pointIndex++;
    points[pointIndex] = currentPoint;
    if (pointIndex == 4)
    {
        points[3] = CGPointMake((points[2].x + points[4].x)/2.0, (points[2].y + points[4].y)/2.0);
        
        [path moveToPoint:points[0]];
        [path addCurveToPoint:points[3] controlPoint1:points[1] controlPoint2:points[2]];
        [self.subPaths addObject:path];
        self.previousPath = path;
        [self setNeedsDisplay];
        
        points[0] = points[3];
        points[1] = points[4];
        pointIndex = 1;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.subPaths.count == 0) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = self.maximumPenWidth;
        path.lineCapStyle = kCGLineCapRound;
        [path moveToPoint:self.previousPoint];
        [path addLineToPoint:[self pointFromTouches:touches]];
        [self.subPaths addObject:path];
    }
    
    [self.paths addObject:self.subPaths];
    [self setNeedsDisplay];
    self.subPaths = nil;
    self.previousPath = nil;
    [self.delegate signatureChangedInView:self];
}

@end

