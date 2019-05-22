//
//  SGCalendarTopView.m
//  CalendarTopView
//
//  Created by sungrow on 2018/8/13.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import "SGCalendarTopView.h"

static const CGFloat TitleViewHeight_ = 44;
static const CGFloat DateControlViewHeight_ = 36;

@interface SGCalendarTopView ()<SGCalendarTitleViewDelegate, SGCalendarControlViewDelegate>

@property (nonatomic, strong) SGCalendarTitleView *titleView;
@property (nonatomic, strong) SGCalendarControlView *dateControlView;
@property (nonatomic, strong) UIView *bottomLine;

/**
 控件起始类型
 */
@property (nonatomic, assign) SGCalendarStartType calendarStartType;

/**
 当前选中的下标: 0 -- 日; 1 -- 月; 2 -- 年; 3 -- 总
 */
@property (nonatomic, assign) NSUInteger selectIndex;

@property (nonatomic, strong) NSLayoutConstraint *titleViewHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *controlViewHeightConstraint;

@end

@implementation SGCalendarTopView

#pragma mark - lazy

- (SGCalendarTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[SGCalendarTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, TitleViewHeight_)];
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

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _bottomLine;
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

#pragma mark - view
- (void)createView {
    self.calendarStartType = !self.calendarStartType ? CalendarStartDay : self.calendarStartType;
    NSMutableArray *itemTitles = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"I18N_COMMON_DAY1", @"日"),NSLocalizedString(@"I18N_COMMON_MONTH", @"月"), NSLocalizedString(@"I18N_COMMON_YEAR", @"年"), NSLocalizedString(@"I18N_COMMON_TOTAL2", @"总")]];
    for (int i = 0 ; i < self.calendarStartType; i ++) {
        [itemTitles removeObjectAtIndex:0];
    }
    
    [self addSubview:self.titleView];
    self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.titleView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.titleView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.titleView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    self.titleViewHeightConstraint = [self.titleView.heightAnchor constraintEqualToConstant:TitleViewHeight_];
    self.titleViewHeightConstraint.active = YES;
    self.titleView.selectedColor = [UIColor colorWithRed:45/255.0 green:142/255.0 blue:229/255.0 alpha:1.0];
    self.titleView.lineColor = self.titleView.selectedColor;
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
    self.controlViewHeightConstraint = [self.dateControlView.heightAnchor constraintEqualToConstant:DateControlViewHeight_];
    self.controlViewHeightConstraint.active = YES;
    
    [self addSubview:self.bottomLine];
    self.bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bottomLine.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.bottomLine.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.bottomLine.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.bottomLine.heightAnchor constraintEqualToConstant:(2 / [UIScreen mainScreen].scale)].active = YES;
    [self updateMaxDate:self.dateControlView.selectDate minDate:self.dateControlView.selectDate];
}

#pragma mark - action

- (void)updateMaxDate:(NSDate *)maxDate minDate:(NSDate *)minDate {
    NSComparisonResult comparisonResult = [self.dateControlView.selectDate compare:maxDate];
    if (comparisonResult == NSOrderedDescending) {
        self.dateControlView.selectDate = maxDate;
    }
    self.dateControlView.maxDate = maxDate;
    self.dateControlView.minDate = minDate;
    
    [self updateDatePickerMode];
    [self changeDateButtonEable];
    [self updateDateButtonTitle];
    [self updateControlViewHeight:NO];
}

/**
 判断切换日期按钮的可用状态
 */
- (void)changeDateButtonEable {
    NSCalendar *calendar = [NSCalendar sharedCalendar];
    NSDateComponents *selectComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.dateControlView.selectDate];
    NSDateComponents *maxComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.dateControlView.maxDate];
    NSDateComponents *minComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.dateControlView.minDate];
    if (self.selectIndex == 0) {
        self.dateControlView.nextButton.hidden = !((maxComp.year > selectComp.year) || (maxComp.year >= selectComp.year && maxComp.month > selectComp.month) || (maxComp.year >= selectComp.year && maxComp.month >= selectComp.month && maxComp.day > selectComp.day));
        self.dateControlView.previousButton.hidden = !((selectComp.year > minComp.year) || (selectComp.year >= minComp.year && selectComp.month > minComp.month)|| (selectComp.year >= minComp.year && selectComp.month >= minComp.month && selectComp.day > minComp.day));
    }else if (self.selectIndex == 1) {
        self.dateControlView.nextButton.hidden = !((maxComp.year > selectComp.year) || (maxComp.year >= selectComp.year && maxComp.month > selectComp.month));
        self.dateControlView.previousButton.hidden = !((selectComp.year > minComp.year) || (selectComp.year >= minComp.year && selectComp.month > minComp.month));
    }else if (self.selectIndex == 2) {
        self.dateControlView.nextButton.hidden = !(maxComp.year > selectComp.year);
        self.dateControlView.previousButton.hidden = !(selectComp.year > minComp.year);
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
    NSCalendar *calendar = [NSCalendar sharedCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.dateControlView.selectDate];
    NSString *value = @"";
    if (self.dateControlView.datePicker.datePickerMode == HooDatePickerModeDate) {
        value = [NSString stringWithFormat:@"%04zd-%02zd-%02zd", comp.year, comp.month, comp.day];
    } else if (self.dateControlView.datePicker.datePickerMode == HooDatePickerModeTime) {
    } else if (self.dateControlView.datePicker.datePickerMode == HooDatePickerModeYearAndMonth){
        value = [NSString stringWithFormat:@"%04zd-%02zd", comp.year, comp.month];
    } else if (self.dateControlView.datePicker.datePickerMode == HooDatePickerModeYear){
        value = [NSString stringWithFormat:@"%04zd", comp.year];
    }
    [self.dateControlView.dateButton setTitle:value forState:UIControlStateNormal];
    if (self.dateDidChange) {
        self.dateDidChange(self.selectIndex, self.dateControlView.selectDate, value);
    }
}

- (void)updateControlViewHeight:(BOOL)animated {
    [self showDateControlView:self.selectIndex != 3 animated:animated];
}

#pragma mark - public action
/**
 控制是否显示 标题栏 (默认显示)

 @param show 是否显示
 @param animated 是否需要动画
 */
- (void)showTitleView:(BOOL)show animated:(BOOL)animated {
    if (show) {
        self.titleViewHeightConstraint.constant = TitleViewHeight_;
        self.titleView.hidden = NO;
    } else {
        self.titleViewHeightConstraint.constant = 0;
        self.titleView.hidden = YES;
    }
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.titleView layoutIfNeeded];
        }];
    }
}

/**
 是否显示 日期切换 (内部逻辑: 切换总时, 隐藏日期切换)

 @param show 是否显示
 @param animated 是否需要动画
 */
- (void)showDateControlView:(BOOL)show animated:(BOOL)animated {
    if (show) {
        self.controlViewHeightConstraint.constant = DateControlViewHeight_;
        self.dateControlView.hidden = NO;
    } else {
        self.controlViewHeightConstraint.constant = 0;
        self.dateControlView.hidden = YES;
    }
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.dateControlView layoutIfNeeded];
        }];
    }
}

#pragma mark - SGCalendarTitleViewDelegate
- (void)calendarTitleView:(SGCalendarTitleView *)titleView didSelectedIndex:(NSInteger)index {
    self.selectIndex = index + self.calendarStartType;
    [self updateDatePickerMode];
    [self changeDateButtonEable];
    [self updateDateButtonTitle];
    [self updateControlViewHeight:YES];
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

- (void)configSelectIndex:(NSInteger)index currentDate:(NSDate *)date {
    BOOL shouldConfigDate = (date != nil) && ([self.dateControlView.selectDate compare:date] != NSOrderedSame);
    if (index >= 0 && index < self.titleView.titleArray.count) {
        if (self.selectIndex != index) {
            if (shouldConfigDate) {
                [self.dateControlView setValue:date forKey:@"_selectDate"];
            }
            [self.titleView curSelectedIndex:index];
            return;
        }
    }
    if (shouldConfigDate) {
        self.dateControlView.selectDate = date;
    }
}

@end
