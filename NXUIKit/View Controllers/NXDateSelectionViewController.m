//
//  DateSelectionViewController.m
//  SPATCO JT Installation
//
//  Created by Joe Sferrazza on 3/3/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXDateSelectionViewController.h"

@interface NXDateSelectionViewController ()
// IBOutlets
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;

@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSDateFormatter *longDateFormatter;

@property (nonatomic, assign) BOOL datePickerModeWasSetByUser;
@end

NSString * const DateSelectionStoryboardIdentifier = @"DateOnlySelector";

@implementation NXDateSelectionViewController
@synthesize date = _date, datePickerMode = _datePickerMode;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(360.0, 280.0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.messageFont) {
        self.messageLabel.font = self.messageFont;
    }
    
    self.messageLabel.text = self.message;
    self.messageLabel.alpha = self.message.length > 0 ? 1.0 : 0.0;
    self.dateLabel.alpha = self.showsBottomDateLabel ? 1.0 : 0.0;
    if (self.datePickerMode == UIDatePickerModeCountDownTimer) {
        self.dateLabel.alpha = 0.0;
        // WTF Apple
        // http://stackoverflow.com/a/20204225/1233314
        dispatch_async(dispatch_get_main_queue(), ^{
            self.datePicker.countDownDuration = self.countdownDuration;
        });
    }

    self.datePicker.date = self.date;
    self.datePicker.datePickerMode = self.datePickerMode;
    self.datePicker.minuteInterval = self.minuteInterval;
    self.datePicker.minimumDate = self.minimumDate;
    self.datePicker.maximumDate = self.maximumDate;
    self.datePicker.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85];
    self.datePicker.layer.cornerRadius = 30.0;
    self.datePicker.layer.masksToBounds = YES;
    [self updateDateLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessors
- (NSDate *)date {
    if (!_date) {
        _date = [NSDate date];
    }
    return _date;
}

- (UIDatePickerMode)datePickerMode {
    if (!self.datePickerModeWasSetByUser) {
        return UIDatePickerModeDate;
    }
    return _datePickerMode;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"EEEE";
    }
    return _formatter;
}

- (NSDateFormatter *)longDateFormatter {
    if (!_longDateFormatter) {
        _longDateFormatter = [[NSDateFormatter alloc] init];
        
        switch (self.datePickerMode) {
            case UIDatePickerModeDate:
                _longDateFormatter.dateStyle = NSDateFormatterLongStyle;
                _longDateFormatter.timeStyle = NSDateFormatterNoStyle;
                break;
            case UIDatePickerModeTime:
                _longDateFormatter.dateStyle = NSDateFormatterNoStyle;
                _longDateFormatter.timeStyle = NSDateFormatterLongStyle;
                break;
            case UIDatePickerModeDateAndTime:
                _longDateFormatter.dateStyle = NSDateFormatterLongStyle;
                _longDateFormatter.timeStyle = NSDateFormatterLongStyle;
                break;
            default:
                break;
        }
    }
    return _longDateFormatter;
}
- (void)setDate:(NSDate *)date {
    _date = date;
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    _datePickerMode = datePickerMode;
    self.datePickerModeWasSetByUser = YES;
}

- (void)setMessage:(NSString *)message {
    _message = message;
    
    self.messageLabel.alpha = message ? 1.0 : 0.0;
}

- (void)setMessageFont:(UIFont *)messageFont {
    _messageFont = messageFont;
    
    self.messageLabel.font = messageFont;
}

- (void)setShowsBottomDateLabel:(BOOL)showsBottomDateLabel {
    _showsBottomDateLabel = showsBottomDateLabel;
    
    self.dateLabel.alpha = showsBottomDateLabel ? 1.0 : 0.0;
}

#pragma mark - Public Class Methods
+ (instancetype)dateSelectionViewController {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"NXUIKitStoryboard" bundle:[NSBundle bundleForClass:[self class]]];
    return [board instantiateViewControllerWithIdentifier:DateSelectionStoryboardIdentifier];
}

#pragma mark - IBActions
- (IBAction)dateChanged:(id)sender {
    self.date = self.datePicker.date;
    
    [self updateDateLabel];
    
    if (self.updateBlock) {
        self.updateBlock(self.date);
    }
}

#pragma mark - Private Instance
- (void)updateDateLabel {
    if (self.datePickerMode == UIDatePickerModeDateAndTime || self.datePickerMode == UIDatePickerModeDate) {
        self.dateLabel.text = [NSString stringWithFormat:@"%@, %@", [self.formatter stringFromDate:self.date], [self.longDateFormatter stringFromDate:self.date]];
    }
    else {
        self.dateLabel.text = [self.longDateFormatter stringFromDate:self.date];
    }
}

@end
