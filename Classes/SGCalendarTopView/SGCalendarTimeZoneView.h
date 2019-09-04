//
//  SGCalendarTimeZoneView.h
//  CalendarTopView
//
//  Created by sungrow on 2018/8/14.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import "SGCalendarTopView.h"

@interface SGCalendarTimeZoneView : SGCalendarTopView

/**
 更新日历控件的日期选择范围
 传入的时区和手机时区不一致时, 最大日期为当前日期+1天
 
 @param timeZone 用户主组织时区
 @param minDate 最小日期
 */
- (void)updateSelectDateRangeWithTimeZone:(NSString *)timeZone minDate:(NSDate *)minDate;

@end
