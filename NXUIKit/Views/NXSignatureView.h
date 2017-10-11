//
//  NXSignatureView.h
//  SPATCO JT Installation
//
//  Created by Joe Sferrazza on 3/2/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NXSignatureView;
@protocol NXSignatureViewDelegate <NSObject>
- (void)signatureChangedInView:(NXSignatureView *)view;
@optional
- (void)didBeginSigningInView:(NXSignatureView *)view;
@end

@interface NXSignatureView : UIView

@property (nonatomic, weak) id <NXSignatureViewDelegate> delegate;

/** Whether or not touches will be handled and drawn to the view.  @p NO by default.  */
@property (nonatomic, assign) IBInspectable BOOL editable;

/**
 @return @p UIImage of the user's signature.
 */
@property (nonatomic, strong, readonly) UIImage *image;

/** The smallest pen width allowed while signing. */
@property (nonatomic, assign) CGFloat minimumPenWidth;

/** The maximum pen width allowed while signing. */
@property (nonatomic, assign) CGFloat maximumPenWidth;

/** Whether or not the view contains at least one user created path. */
@property (nonatomic, assign, readonly) BOOL userHasSigned;

/** Whether or not the signature line & text should be hidden. @p NO by default. */
@property (nonatomic, assign) IBInspectable BOOL shouldHideSignatureLine;

/** The text to display below the signature line. Blank by default. */
@property (nonatomic, copy) IBInspectable NSString *signatureLineText;

/** Removes the full user's signature from the view. */
- (void)clear;

/** Prevents editing and displays the specified image over the signature view. Pass @p nil to remove the current image. */
- (void)displaySignatureImage:(UIImage *)image;

/** Removes the last path in the user's signature. */
- (void)undo;


@end
