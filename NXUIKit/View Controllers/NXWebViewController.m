//
//  NXWebViewController.m
//  NXUIKit
//
//  Created by Joe Sferrazza on 9/4/15.
//  Copyright © 2015 Nexcom. All rights reserved.
//

#import "NXWebViewController.h"

@interface NXWebViewController () <UIToolbarDelegate, UIWebViewDelegate>
// IBOutlets
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIToolbar *topToolbar;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

@property (nonatomic, assign) NSInteger numberOfActiveRequests;
@end

static NSUInteger const FlexibleSpaceTag = 3;
static NSString * const StoryboardIdentifierForWebBrowser = @"NXWebViewController";

@implementation NXWebViewController
+ (instancetype)instantiateFromStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NXUIKitStoryboard" bundle:[NSBundle bundleForClass:[NXWebViewController class]]];
    return [storyboard instantiateViewControllerWithIdentifier:StoryboardIdentifierForWebBrowser];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.loadingIndicator.hidesWhenStopped = YES;
    
    // Insert the loading indicator just before the flexible space
    UIBarButtonItem *loadingBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.loadingIndicator];
    NSMutableArray *items = [self.topToolbar.items mutableCopy];
    [self.topToolbar.items enumerateObjectsUsingBlock:^(UIBarButtonItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == FlexibleSpaceTag) {
            [items insertObject:loadingBarButton atIndex:idx];
            *stop = YES;
        }
    }];
    self.topToolbar.items = [items copy];
    
    self.backButton.enabled = self.forwardButton.enabled = NO;
    
    if (self.configurationHandler) {
        self.configurationHandler(self.topToolbar, self.titleLabel);
    }
    
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.titleLabel.text = self.title;
    self.loadingIndicator.color = self.topToolbar.tintColor;
    self.doneButton.tintColor = self.topToolbar.tintColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Accessors
- (void)setNumberOfActiveRequests:(NSInteger)numberOfActiveRequests {
    _numberOfActiveRequests = numberOfActiveRequests;
    
    if (numberOfActiveRequests <= 0) {
        numberOfActiveRequests = 0;
        [self.loadingIndicator stopAnimating];
    }
    else {
        [self.loadingIndicator startAnimating];
    }
    
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    if (self.isViewLoaded) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
}

#pragma mark - IBActions
- (IBAction)doneWasTapped:(id)sender {
    if (self.doneBlock) {
        self.doneBlock();
    }
    else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}

- (IBAction)goForward:(id)sender {
    [self.webView goForward];
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.numberOfActiveRequests--;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.numberOfActiveRequests++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.numberOfActiveRequests--;
}

#pragma mark - UIToolbarDelegate
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

@end
