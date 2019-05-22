//
//  SGCalendarTimeZoneView.m
//  CalendarTopView
//
//  Created by sungrow on 2018/8/14.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import "SGCalendarTimeZoneView.h"

@interface SGCalendarTimeZoneView ()

/**
 当前使用的时区
 */
@property (nonatomic, copy) NSString *currentTimeZone;

@end

@implementation SGCalendarTimeZoneView

- (void)createView {
    [super createView];
    
    [self updateSelectDateRangeWithTimeZone:@"GMT+9"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeZoneDidChange) name:NSSystemTimeZoneDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSSystemTimeZoneDidChangeNotification object:nil];
}

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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *max_date = [NSDate date];
    // TODO: 如果和当前时区和系统时区不一致,则默认加一天
    if (1) {
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
    [self updateMaxDate:maxDate minDate:minDate];
}

@end
