//
//  SGCalendarTimeZoneView.m
//  CalendarTopView
//
//  Created by sungrow on 2018/8/14.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import "SGCalendarTimeZoneView.h"
#import <SGCategoriesObjC/NSTimeZone+SGGMT.h>

@interface SGCalendarTimeZoneView ()

/**
 当前使用的时区
 */
@property (nonatomic, copy) NSString *currentTimeZone;

@end

@implementation SGCalendarTimeZoneView

- (void)createView {
    [super createView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelectDateRange) name:NSSystemTimeZoneDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelectDateRange) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSSystemTimeZoneDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)updateSelectDateRange {
    [self updateSelectDateRangeWithTimeZone:self.currentTimeZone minDate:self.dateControlView.minDate];
}

/**
 更新日历控件的日期选择范围
 传入的时区和手机时区不一致时, 最大日期为当前日期+1天

 @param timeZone 用户主组织时区
 @param minDate 最小日期
 */
- (void)updateSelectDateRangeWithTimeZone:(NSString *)timeZone minDate:(NSDate *)minDate {
    if (!timeZone) return;
    NSDate *maxDate = [NSDate date];
    if (!minDate) {
        minDate = maxDate;
    }
    self.currentTimeZone = timeZone;
    // 如果和当前时区和系统时区不一致,则默认加一天
    if (![[NSTimeZone systemTimeZone].sg_abbreviationGMT isEqualToString:timeZone]) {
        maxDate = [NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:maxDate];
    }
    [self updateMaxDate:maxDate minDate:minDate];
}

@end
