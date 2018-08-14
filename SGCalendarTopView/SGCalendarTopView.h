//
//  SGCalendarTopView.h
//  CalendarTopView
//
//  Created by sungrow on 2018/8/13.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGCalendarTitleView.h"
#import "SGCalendarControlView.h"

typedef enum : NSUInteger {
    CalendarStartDay = 0,       // 日 -- 月 -- 年 -- 总
    CalendarStartMonth,         // 月 -- 年 -- 总
    CalendarStartYear,          // 年 -- 总
    CalendarStartTotal,         // 总
} SGCalendarStartType;

@interface SGCalendarTopView : UIView

/**
 回调函数: selectIndex 标题下标; selectDate 选中日期; title 显示的日期文本
 */
@property (nonatomic, copy) void (^dateDidChange)(NSInteger selectIndex, NSDate *selectDate, NSString *title);

@property (nonatomic, strong, readonly) SGCalendarTitleView *titleView;
@property (nonatomic, strong, readonly) SGCalendarControlView *dateControlView;

- (instancetype)initWithCalendarStartType:(SGCalendarStartType)type selectIndex:(NSInteger)index;

- (void)updateSelectDateRangeWithTimeZone:(NSString *)timeZone;

- (void)showTitleView:(BOOL)show animated:(BOOL)animated;

- (void)showDateControlView:(BOOL)show animated:(BOOL)animated;

@end
