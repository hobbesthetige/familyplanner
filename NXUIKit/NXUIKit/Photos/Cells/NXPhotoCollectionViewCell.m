//
//  NXPhotoCollectionViewCell.m
//  NXMedia
//
//  Created by Joe Sferrazza on 4/3/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXPhotoCollectionViewCell.h"
@interface NXPhotoCollectionViewCell()
@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) IBOutlet UIVisualEffectView *actionBlurView;
@property (nonatomic, strong) IBOutlet UIVisualEffectView *deleteBlurView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *actionCenterXConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *deleteCenterXConstraint;
@property (nonatomic, strong) UIView *dimmingView;
@end

NSString * const NXPhotoCollectionViewCellIdentifier = @"PhotoCollectionViewCell";
static CGFloat const ButtonXOffsetAmount = 40.0;

@implementation NXPhotoCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Setup and hide the blur view
    [self.actionBlurView.layer setCornerRadius:(CGRectGetHeight(self.actionBlurView.bounds) / 2.0)];
    [self.actionBlurView.layer setMasksToBounds:YES];
    [self.actionBlurView setAlpha:0.0];
    self.actionBlurView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    self.actionCenterXConstraint.constant = 0.0;
    
    [self.deleteBlurView.layer setCornerRadius:(CGRectGetHeight(self.deleteBlurView.bounds) / 2.0)];
    [self.deleteBlurView.layer setMasksToBounds:YES];
    [self.deleteBlurView setAlpha:0.0];
    self.deleteBlurView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    self.deleteCenterXConstraint.constant = 0.0;
    
    // Setup the image tap gesture recognizer
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageWasTapped:)];
    self.photoImageView.userInteractionEnabled = YES;
    [self.photoImageView addGestureRecognizer:tapRecognizer];
    
    // Add the dimming view and hide it
    self.dimmingView = [[UIView alloc] initWithFrame:self.photoImageView.bounds];
    self.dimmingView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:0.33];
    [self.photoImageView addSubview:self.dimmingView];
    
    self.dimmingView.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *dimmingView = self.dimmingView;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(dimmingView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dimmingView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[dimmingView]|" options:0 metrics:nil views:views]];
    
    self.dimmingView.alpha = 0.0;
}

- (void)setPhoto:(UIImage *)photo {
    _photo = photo;
    
    self.photoImageView.image = photo;
}

#pragma mark - Actions
- (IBAction)deleteWasTapped:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self.photoImageView.image);
    }
    [self toggleBlurView];
}

- (IBAction)enlargeWasTapped:(id)sender {
    if (self.actionBlock) {
        self.actionBlock(self.photoImageView.image);
    }
    [self toggleBlurView];
}

- (void)imageWasTapped:(UITapGestureRecognizer *)recognizer {
    [self toggleBlurView];
}


#pragma mark - Private
- (void)toggleBlurView {
    if (self.actionBlurView.alpha == 0.0) {
        // Show the buttons
        // Don't offset the action button if we won't be showing the delete button
        self.actionCenterXConstraint.constant = self.deleteBlock ? ButtonXOffsetAmount : 0.0;
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:0.0 options:0 animations:^{
            [self.actionBlurView setAlpha:1.0];
            self.dimmingView.alpha = 1.0;
            self.actionBlurView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            [self layoutIfNeeded];
        } completion:nil];
        
        self.deleteCenterXConstraint.constant = -ButtonXOffsetAmount;
        [UIView animateWithDuration:0.3 delay:0.15 usingSpringWithDamping:0.55 initialSpringVelocity:0.0 options:0 animations:^{
            [self.deleteBlurView setAlpha:self.deleteBlock ? 1.0 : 0.0];
            self.deleteBlurView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            [self layoutIfNeeded];
        } completion:nil];
    }
    else {
        // Hide the buttons
        self.actionCenterXConstraint.constant = self.deleteCenterXConstraint.constant = 0.0;
        
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.65 initialSpringVelocity:0.0 options:0 animations:^{
            [self.actionBlurView setAlpha:0.0];
            [self.deleteBlurView setAlpha:0.0];
            self.dimmingView.alpha = 0.0;
            self.actionBlurView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
            self.deleteBlurView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
            [self layoutIfNeeded];
        } completion:nil];
    }
}
@end
