//
//  SGCalendarControlView.m
//  CalendarTopView
//
//  Created by sungrow on 2018/8/13.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import "SGCalendarControlView.h"
#import <SGSinglePickerController/SGSinglePickerController-Swift.h>
#import <SGTheme/SGTheme.h>
#import <SGUpper/SGUpper-Swift.h>

@interface SGCalendarControlView ()

/**
 向前
 */
@property (nonatomic, strong) UIButton *previousButton;

/**
 日期
 */
@property (nonatomic, strong) UIButton *dateButton;

/**
 向后
 */
@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation SGCalendarControlView

#pragma mark - lazy
- (UIButton *)previousButton {
    if (!_previousButton) {
        _previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previousButton setTitle:@"◀️" forState:UIControlStateNormal];
        [_previousButton addTarget:self action:@selector(previousButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previousButton;
}

- (UIButton *)dateButton {
    if (!_dateButton) {
        _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dateButton addTarget:self action:@selector(dateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _dateButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _dateButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"▶️" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

#pragma mark - init

- (instancetype)init {
    if (self = [super init]) {
        [self createView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createView];
}

#pragma mark - view
- (void)createView {
    [self addSubview:self.previousButton];
    self.previousButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.previousButton.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.previousButton.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.previousButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.previousButton.widthAnchor constraintEqualToConstant:80].active = YES;
    
    [self addSubview:self.nextButton];
    self.nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nextButton.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.nextButton.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.nextButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.nextButton.widthAnchor constraintEqualToAnchor:self.previousButton.widthAnchor].active = YES;
    
    [self addSubview:self.dateButton];
    self.dateButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dateButton.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.dateButton.rightAnchor constraintEqualToAnchor:self.nextButton.leftAnchor].active = YES;
    [self.dateButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.dateButton.leftAnchor constraintEqualToAnchor:self.previousButton.rightAnchor].active = YES;
    
    self.selectDate = [NSDate date];
    self.maxDate = [NSDate date];
    self.minDate = self.maxDate;
}

#pragma mark - action
- (void)previousButtonAction:(UIButton *)sender {
    if ([self.controlDelegate conformsToProtocol:@protocol(SGCalendarControlViewDelegate)]) {
        if ([self.controlDelegate respondsToSelector:@selector(calendarControlView:previousButtonAction:)]) {
            [self.controlDelegate calendarControlView:self previousButtonAction:sender];
        }
    }
}

- (void)nextButtonAction:(UIButton *)sender {
    if ([self.controlDelegate conformsToProtocol:@protocol(SGCalendarControlViewDelegate)]) {
        if ([self.controlDelegate respondsToSelector:@selector(calendarControlView:nextButtonAction:)]) {
            [self.controlDelegate calendarControlView:self nextButtonAction:sender];
        }
    }
}

- (void)dateButtonAction:(UIButton *)sender {
    [self showDatePickView];
}

- (void)setSelectDate:(NSDate *)selectDate {
    _selectDate = selectDate;
    if ([self.controlDelegate conformsToProtocol:@protocol(SGCalendarControlViewDelegate)]) {
        if ([self.controlDelegate respondsToSelector:@selector(calendarControlView:didChangeSelectDate:)]) {
            [self.controlDelegate calendarControlView:self didChangeSelectDate:self.selectDate];
        }
    }
}

- (void)showDatePickView {
    [self.recentlyViewController.view endEditing:YES];
    PGDatePickManager *datePickMangaer = [[PGDatePickManager alloc] init];
    datePickMangaer.headerViewBackgroundColor = UIColor.whiteColor;
    datePickMangaer.cancelButtonText = NSLocalizedString(@"I18N_COMMON_CANCLE", @"取消").sgUppercase;
    datePickMangaer.confirmButtonText = NSLocalizedString(@"I18N_COMMON_DETERMINE", @"确定").sgUppercase;
    datePickMangaer.cancelButtonTextColor = SGTheme.negative_color.color;
    datePickMangaer.confirmButtonTextColor = SGTheme.brand_color.color;
    PGDatePicker *datePicker = datePickMangaer.datePicker;
    datePicker.datePickerMode = self.datePickerMode;
    datePicker.showUnit = PGShowUnitTypeNone;
    datePicker.isHiddenMiddleText = NO;
    datePicker.middleTextColor = [UIColor clearColor];
    datePicker.textColorOfOtherRow = SGTheme.disable_color.color;
    datePicker.lineBackgroundColor = SGTheme.brand_color.color;
    datePicker.textColorOfSelectedRow = SGTheme.brand_color.color;
    [datePicker setMinimumDate:self.minDate];
    [datePicker setMaximumDate:self.maxDate];
    [datePicker setDate:self.selectDate];
    
    if (self.configDatePick) {
        self.configDatePick(datePickMangaer);
    }
    
    __weak typeof(self) weakSelf = self;
    [datePicker setSelectedDate:^(NSDateComponents *dateComponents) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyyMMddHHmmss";
        NSString *dateStr = [NSString stringWithFormat:@"%zd%02zd%02zd%02zd%02zd%02zd", dateComponents.year, dateComponents.month, dateComponents.day, dateComponents.hour, dateComponents.minute, dateComponents.second];
        NSDate *date = [fmt dateFromString:dateStr];
        weakSelf.selectDate = date;
    }];
    [self.recentlyViewController presentViewController:datePickMangaer animated:YES completion:nil];
}

@end
