//
//  SGCalendarControlView.h
//  CalendarTopView
//
//  Created by sungrow on 2018/8/13.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PGDatePicker/PGDatePicker.h>
#import <PGDatePicker/PGDatePickManager.h>
@class SGCalendarControlView;

@protocol SGCalendarControlViewDelegate <NSObject>

- (void)calendarControlView:(SGCalendarControlView *)view didChangeSelectDate:(NSDate *)date;
- (void)calendarControlView:(SGCalendarControlView *)view previousButtonAction:(UIButton *)sender;
- (void)calendarControlView:(SGCalendarControlView *)view nextButtonAction:(UIButton *)sender;

@end

@interface SGCalendarControlView : UIView

/**
 弹出的日期选择控件的格式
 */
@property (nonatomic, assign) PGDatePickerMode datePickerMode;

/**
 选中的日期
 */
@property (nonatomic, strong) NSDate *selectDate;

/**
 最大日期
 */
@property (nonatomic, strong) NSDate *maxDate;

/**
 最小日期
 */
@property (nonatomic, strong) NSDate *minDate;

/**
 代理
 */
@property (nonatomic, weak) id <SGCalendarControlViewDelegate> controlDelegate;

/**
 自定义日期选择控件的样式
 */
@property (nonatomic, copy) void (^configDatePick)(PGDatePickManager *datePickManager);

#pragma mark - readonly
@property (nonatomic, strong, readonly) UIButton *previousButton;

@property (nonatomic, strong, readonly) UIButton *dateButton;

@property (nonatomic, strong, readonly) UIButton *nextButton;

@end
