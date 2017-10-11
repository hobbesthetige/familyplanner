//
//  NXPhotoViewerViewController.m
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 4/6/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXPhotoViewerViewController.h"
#import <NXUIKit/NXUIKit-Swift.h>
@import NXConstraintKit;

static NSString *const PhotoViewerInNavigationControllerStoryboardID = @"PhotoViewerInNavigationController";
static NSString *const PhotoViewerStoryboardID = @"PhotoViewerController";

@interface NXPhotoViewerViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation NXPhotoViewerViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
    self.imageView.image = self.imageToDisplay;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:self.imageView];
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.scrollView);
    }];
    self.scrollView.delegate = self;
    [self.scrollView setMaximumZoomScale:3.0];
    [self.scrollView setMinimumZoomScale:1.0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.actionBlock) {
        UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(performAction)];
        self.navigationController.navigationItem.rightBarButtonItem = actionButton;
    }
}

#pragma mark - UIViewController
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Accessors
- (void)setImageToDisplay:(UIImage *)imageToDisplay {
    _imageToDisplay = imageToDisplay;
    
    self.imageView.image = imageToDisplay;
}

#pragma mark - Public Class Methods
+ (UINavigationController *)instantiateInNavControllerWithImage:(UIImage *)image {
    UINavigationController *navigationController = [[UIStoryboard photoStoryboard] instantiateViewControllerWithIdentifier:PhotoViewerInNavigationControllerStoryboardID];
    [(NXPhotoViewerViewController *)navigationController.topViewController setImageToDisplay:image];
    return navigationController;
}

+ (instancetype)instantiateWithImage:(UIImage *)image {
    NXPhotoViewerViewController *viewer = [[UIStoryboard photoStoryboard] instantiateViewControllerWithIdentifier:PhotoViewerStoryboardID];
    viewer.imageToDisplay = image;
    return viewer;
}

#pragma mark - Private Instance Methods
- (IBAction)closeWasTapped:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)performAction {
    if (self.actionBlock) {
        self.actionBlock(self.imageToDisplay);
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
@end
