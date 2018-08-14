//
//  SGCalendarTopView.m
//  CalendarTopView
//
//  Created by sungrow on 2018/8/13.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import "SGCalendarTopView.h"
#import "SGCalendarTitleView.h"
#import "SGCalendarControlView.h"

@interface SGCalendarTopView ()<SGCalendarTitleViewDelegate, SGCalendarControlViewDelegate>

@property (nonatomic, strong) SGCalendarTitleView *titleView;
@property (nonatomic, strong) SGCalendarControlView *dateControlView;

/**
 控件起始类型
 */
@property (nonatomic, assign) SGCalendarStartType calendarStartType;

/**
 当前选中的下标: 0 -- 日; 1 -- 月; 2 -- 年; 3 -- 总
 */
@property (nonatomic, assign) NSUInteger selectIndex;

/**
 当前使用的时区
 */
@property (nonatomic, copy) NSString *currentTimeZone;

@property (nonatomic, strong) NSLayoutConstraint *controlViewHeightConstraint;

@end

@implementation SGCalendarTopView

#pragma mark - lazy

- (SGCalendarTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[SGCalendarTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        _titleView.backgroundColor = [UIColor redColor];
        _titleView.delegate = self;
    }
    return _titleView;
}

- (SGCalendarControlView *)dateControlView {
    if (!_dateControlView) {
        _dateControlView = [[SGCalendarControlView alloc] init];
        _dateControlView.selectDate = [NSDate date];
        _dateControlView.controlDelegate = self;
    }
    return _dateControlView;
}


#pragma mark - init

- (instancetype)init {
    if (self = [super init]) {
        self.calendarStartType = CalendarStartDay;
        self.selectIndex = 0;
        [self createView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.calendarStartType = CalendarStartDay;
    self.selectIndex = 0;
    [self createView];
}

- (instancetype)initWithCalendarStartType:(SGCalendarStartType)type selectIndex:(NSInteger)index {
    if (self = [super init]) {
        self.calendarStartType = type;
        self.selectIndex = index;
        [self createView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSSystemTimeZoneDidChangeNotification object:nil];
    NSLog(@"%s", __func__);
}

#pragma mark - view
- (void)createView {
    self.calendarStartType = !self.calendarStartType ? CalendarStartDay : self.calendarStartType;
    NSMutableArray *itemTitles = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"日", @"日"),NSLocalizedString(@"月", @"月"), NSLocalizedString(@"年", @"年"), NSLocalizedString(@"总", @"总")]];
    for (int i = 0 ; i < self.calendarStartType; i ++) {
        [itemTitles removeObjectAtIndex:0];
    }
    
    [self addSubview:self.titleView];
    self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.titleView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.titleView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.titleView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.titleView.heightAnchor constraintEqualToConstant:44].active = YES;
    
    self.titleView.selectedColor = [UIColor blueColor];
    self.titleView.noSlectedColor = [UIColor blackColor];
    self.titleView.titleArray = itemTitles;
    NSInteger index = self.selectIndex - self.calendarStartType;
    if (index < 0) {
        index = 0;
    }
    if (index > (itemTitles.count - 1)) {
        index = itemTitles.count - 1;
    }
    self.titleView.currentIndex = index;
    
    [self addSubview:self.dateControlView];
    self.dateControlView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dateControlView.topAnchor constraintEqualToAnchor:self.titleView.bottomAnchor].active = YES;
    [self.dateControlView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.dateControlView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.dateControlView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    self.controlViewHeightConstraint = [self.dateControlView.heightAnchor constraintEqualToConstant:44];
    self.controlViewHeightConstraint.active = YES;
    [self updateSelectDateRangeWithTimeZone:@"GMT+9"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeZoneDidChange) name:NSSystemTimeZoneDidChangeNotification object:nil];
}

#pragma mark - action

- (void)timeZoneDidChange {
    [self updateSelectDateRangeWithTimeZone:self.currentTimeZone];
}

/**
 更新日历控件的日期选择范围
 
 @param timeZone 依据时区
 */
- (void)updateSelectDateRangeWithTimeZone:(NSString *)timeZone {
    if (!timeZone) return;
    [[NSUserDefaults standardUserDefaults] setValue:@"20170112" forKey:@"min_date"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.currentTimeZone = timeZone;
    NSDateFormatter *dateFormatter = self.dateControlView.dateFormatter;
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *max_date = [NSDate date];
    // TODO: 如果和当前时区和系统时区不一致,则默认加一天
    if (0) {
        max_date = [NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:[NSDate date]];
    }
    NSString *currentDate = [dateFormatter stringFromDate:max_date];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *maxDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 23:59:59", currentDate]];
    NSString *minDateStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"min_date"];
    NSDate *minDate;
    if (minDateStr == nil || minDateStr.length <= 0) {
        minDate = maxDate;
    } else {
        NSString *min_dateStr = [NSString stringWithFormat:@"%@235959",minDateStr];
        dateFormatter.dateFormat = @"yyyyMMddHHmmss";
        NSDate *min_dateStrDate = [dateFormatter dateFromString:min_dateStr];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        minDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:min_dateStrDate]];
    }
    NSComparisonResult comparisonResult = [self.dateControlView.selectDate compare:maxDate];
    if (comparisonResult == NSOrderedDescending) {
        self.dateControlView.selectDate = maxDate;
    }
    self.dateControlView.maxDate = maxDate;
    self.dateControlView.minDate = minDate;
    
    [self updateDatePickerMode];
    [self changeDateButtonEable];
    [self updateDateButtonTitle];
    [self updateControlViewHeight];
}

/**
 判断切换日期按钮的可用状态
 */
- (void)changeDateButtonEable {
    NSDateFormatter *fmt = self.dateControlView.dateFormatter;
    fmt.dateFormat = @"dd";
    NSString *selectDay = [fmt stringFromDate:self.dateControlView.selectDate];
    NSString *maxDay = [fmt stringFromDate:self.dateControlView.maxDate];
    NSString *minDay = [fmt stringFromDate:self.dateControlView.minDate];
    fmt.dateFormat = @"MM";
    NSString *selectMonth = [fmt stringFromDate:self.dateControlView.selectDate];
    NSString *maxMonth = [fmt stringFromDate:self.dateControlView.maxDate];
    NSString *minMonth = [fmt stringFromDate:self.dateControlView.minDate];
    fmt.dateFormat = @"yyyy";
    NSString *selectYear = [fmt stringFromDate:self.dateControlView.selectDate];
    NSString *maxYear = [fmt stringFromDate:self.dateControlView.maxDate];
    NSString *minYear = [fmt stringFromDate:self.dateControlView.minDate];
    
    if (self.selectIndex == 0) {
        self.dateControlView.nextButton.hidden = !(([maxYear floatValue] > [selectYear floatValue]) || ([maxYear floatValue] >= [selectYear floatValue] && [maxMonth floatValue] > [selectMonth floatValue]) || ([maxYear floatValue] >= [selectYear floatValue] && [maxMonth floatValue] >= [selectMonth floatValue] && [maxDay floatValue] > [selectDay floatValue]));
        self.dateControlView.previousButton.hidden = !(([selectYear floatValue] > [minYear floatValue]) || ([selectYear floatValue] >= [minYear floatValue] && [selectMonth floatValue] > [minMonth floatValue])|| ([selectYear floatValue] >= [minYear floatValue] && [selectMonth floatValue] >= [minMonth floatValue] && [selectDay floatValue] > [minDay floatValue]));
    }else if (self.selectIndex == 1) {
        self.dateControlView.nextButton.hidden = !(([maxYear floatValue] > [selectYear floatValue]) || ([maxYear floatValue] >= [selectYear floatValue] && [maxMonth floatValue] > [selectMonth floatValue]));
        self.dateControlView.previousButton.hidden = !(([selectYear floatValue] > [minYear floatValue]) || ([selectYear floatValue] >= [minYear floatValue] && [selectMonth floatValue] > [minMonth floatValue] ));
    }else if (self.selectIndex == 2) {
        self.dateControlView.nextButton.hidden = !([maxYear floatValue] > [selectYear floatValue]);
        self.dateControlView.previousButton.hidden = !([selectYear floatValue] > [minYear floatValue]);
    }
}

- (void)updateDatePickerMode {
    switch (self.selectIndex) {
        case 0:
            self.dateControlView.datePicker.datePickerMode = HooDatePickerModeDate;
            break;
        case 1:
            self.dateControlView.datePicker.datePickerMode = HooDatePickerModeYearAndMonth;
            break;
        case 2:
            self.dateControlView.datePicker.datePickerMode = HooDatePickerModeYear;
            break;
        default:
            break;
    }
}

- (void)updateDateButtonTitle {
    NSDateFormatter *dateFormatter = self.dateControlView.dateFormatter;
    if (self.dateControlView.datePicker.datePickerMode == HooDatePickerModeDate) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    } else if (self.dateControlView.datePicker.datePickerMode == HooDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else if (self.dateControlView.datePicker.datePickerMode == HooDatePickerModeYearAndMonth){
        [dateFormatter setDateFormat:@"yyyy-MM"];
    } else if (self.dateControlView.datePicker.datePickerMode == HooDatePickerModeYear){
        [dateFormatter setDateFormat:@"yyyy"];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString *value = [dateFormatter stringFromDate:self.dateControlView.selectDate];
    [self.dateControlView.dateButton setTitle:value forState:UIControlStateNormal];
}

- (void)updateControlViewHeight {
    if (self.selectIndex == 3) {
        self.controlViewHeightConstraint.constant = 0;
        self.dateControlView.hidden = YES;
    } else {
        self.controlViewHeightConstraint.constant = 44;
        self.dateControlView.hidden = NO;
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.dateControlView layoutIfNeeded];
    }];
}

#pragma mark - SGCalendarTitleViewDelegate
- (void)calendarTitleView:(SGCalendarTitleView *)titleView didSelectedIndex:(NSInteger)index {
    self.selectIndex = index + self.calendarStartType;
    [self updateDatePickerMode];
    [self changeDateButtonEable];
    [self updateDateButtonTitle];
    [self updateControlViewHeight];
}

#pragma mark - SGCalendarControlViewDelegate
- (void)calendarControlView:(SGCalendarControlView *)view previousButtonAction:(UIButton *)sender {
    if (self.selectIndex == 0){
        self.dateControlView.selectDate = [self _getPriousorLaterDateFromDate:self.dateControlView.selectDate withDiff:-1 type:0];
    } else if (self.selectIndex == 1){
        self.dateControlView.selectDate = [self _getPriousorLaterDateFromDate:self.dateControlView.selectDate withDiff:-1 type:1];
    } else if (self.selectIndex == 2){
        self.dateControlView.selectDate = [self _getPriousorLaterDateFromDate:self.dateControlView.selectDate withDiff:-1 type:2];
    }
}

- (void)calendarControlView:(SGCalendarControlView *)view nextButtonAction:(UIButton *)sender {
    if (self.selectIndex == 0){
        self.dateControlView.selectDate = [self _getPriousorLaterDateFromDate:self.dateControlView.selectDate withDiff:1 type:0];
    } else if (self.selectIndex == 1){
        self.dateControlView.selectDate = [self _getPriousorLaterDateFromDate:self.dateControlView.selectDate withDiff:1 type:1];
    } else if (self.selectIndex == 2){
        self.dateControlView.selectDate = [self _getPriousorLaterDateFromDate:self.dateControlView.selectDate withDiff:1 type:2];
    }
}

- (void)calendarControlView:(SGCalendarControlView *)view didChangeSelectDate:(NSDate *)date {
    NSLog(@"date = %@", date);
    [self changeDateButtonEable];
    [self updateDateButtonTitle];
}

#pragma mark - assist
- (NSDate *)_getPriousorLaterDateFromDate:(NSDate *)date withDiff:(int)diff type:(NSInteger)type {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    switch (type) {
        case 0:
            [comps setDay:diff];
            break;
        case 1:
            [comps setMonth:diff];
            break;
        case 2:
            [comps setYear:diff];
            break;
            
        default:
            break;
    }
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
}

@end
