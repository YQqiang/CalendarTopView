//
//  SGCalendarControlView.m
//  CalendarTopView
//
//  Created by sungrow on 2018/8/13.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import "SGCalendarControlView.h"

@interface SGCalendarControlView ()<HooDatePickerDelegate>

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

/**
 日期选择
 */
@property (nonatomic, strong) HooDatePicker *datePicker;

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

- (HooDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[HooDatePicker alloc] initWithSuperView:[UIApplication sharedApplication].keyWindow];
        _datePicker.timeZone = self.timeZone;
        _datePicker.calendar.timeZone = self.timeZone;
        _datePicker.highlightColor = [UIColor lightGrayColor];
        _datePicker.delegate = self;
        [_datePicker setDate:_selectDate animated:NO];
    }
    return _datePicker;
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

- (void)dealloc {
    [self.datePicker removeFromSuperview];
    self.datePicker = nil;
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
    [self.datePicker setDate:self.selectDate animated:NO];
    [self.datePicker show];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.window) {
        BOOL isShow = self.datePicker.isOpen;
        [self.datePicker reLayoutSubviews];
        if (isShow) {
            [self.datePicker show];
        }
    }
}

#pragma mark - set
- (void)setMaxDate:(NSDate *)maxDate {
    _maxDate = maxDate;
    self.datePicker.maximumDate = maxDate;
}

- (void)setMinDate:(NSDate *)minDate {
    _minDate = minDate;
    self.datePicker.minimumDate = minDate;
}

#pragma mark - get
- (NSTimeZone *)timeZone {
    return [NSTimeZone systemTimeZone];;
}

- (NSLocale *)locale {
    return [NSLocale currentLocale];
}

- (NSDateFormatter *)dateFormatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.timeZone = self.timeZone;
    fmt.locale = self.locale;
    fmt.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return fmt;
}

/**
 获取 datePicker 工具条的取消按钮
 
 @return 取消按钮
 */
- (UIButton *)datePickerCancelButton {
    UIStackView *tooBar = [self datePickerHeaderView];
    for (UIView *subV in tooBar.arrangedSubviews) {
        if ([subV isKindOfClass:[UIButton class]]) {
            return (UIButton *)subV;
        }
    }
    return nil;
}

/**
 获取 datePicker 工具条的确认按钮

 @return 确认按钮
 */
- (UIButton *)datePickerConfirmButton {
    UIStackView *tooBar = [self datePickerHeaderView];
    for (UIView *subV in tooBar.arrangedSubviews.reverseObjectEnumerator) {
        if ([subV isKindOfClass:[UIButton class]]) {
            return (UIButton *)subV;
        }
    }
    return nil;
}

/**
 获取 datePicker 的工具条

 @return 工具条
 */
- (UIStackView *)datePickerHeaderView {
    if ([self.datePicker respondsToSelector:NSSelectorFromString(@"headerView")]) {
        UIView *tooBar = [self.datePicker valueForKey:@"headerView"];
        for (UIView *subv in tooBar.subviews) {
            if ([subv isKindOfClass:[UIStackView class]]) {
                return (UIStackView *)subv;
            }
        }
    }
    return nil;
}

#pragma mark - HooDatePickerDelegate
- (void)datePicker:(HooDatePicker *)datePicker didCancel:(UIButton *)sender {
    
}

- (void)datePicker:(HooDatePicker *)datePicker dateDidChange:(NSDate *)date {
    
}

- (void)datePicker:(HooDatePicker *)dataPicker didSelectedDate:(NSDate *)date {
    self.selectDate = date;
}

- (void)setSelectDate:(NSDate *)selectDate {
    _selectDate = selectDate;
    if ([self.controlDelegate conformsToProtocol:@protocol(SGCalendarControlViewDelegate)]) {
        if ([self.controlDelegate respondsToSelector:@selector(calendarControlView:didChangeSelectDate:)]) {
            [self.controlDelegate calendarControlView:self didChangeSelectDate:self.selectDate];
        }
    }
}

@end
