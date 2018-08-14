//
//  SGCalendarTopView.h
//  CalendarTopView
//
//  Created by sungrow on 2018/8/13.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CalendarStartDay = 0,       // 日 -- 月 -- 年 -- 总
    CalendarStartMonth,         // 月 -- 年 -- 总
    CalendarStartYear,          // 年 -- 总
    CalendarStartTotal,         // 总
} SGCalendarStartType;

@interface SGCalendarTopView : UIView

- (instancetype)initWithCalendarStartType:(SGCalendarStartType)type selectIndex:(NSInteger)index;

@end
