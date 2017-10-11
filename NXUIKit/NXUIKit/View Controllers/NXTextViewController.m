//
//  TextViewController.m
//  SPATCO ProjectTrack
//
//  Created by Joe Sferrazza on 3/23/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXTextViewController.h"

@import NXConstraintKit;

@interface NXTextViewController ()
@property (nonatomic, strong, readwrite) UITextView *textView;
@end

@implementation NXTextViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.textView];
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    self.textView.editable = !self.readOnly;
    self.textView.text = self.text;
    
    if (!self.readOnly) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveWasTapped:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelWasTapped:)];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.readOnly) {
        [self.textView becomeFirstResponder];
    }
}

#pragma mark - UIViewController
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Accessors
- (void)setReadOnly:(BOOL)readOnly {
    _readOnly = readOnly;
    self.textView.editable = !self.readOnly;
}

- (void)setText:(NSString *)text {
    _text = text;
    
    self.textView.text = text;
}

#pragma mark - Private Instance
- (void)cancelWasTapped:(id)sender {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)saveWasTapped:(id)sender {
    if (self.saveBlock) {
        self.saveBlock(self.textView.text);
    }
}

@end
