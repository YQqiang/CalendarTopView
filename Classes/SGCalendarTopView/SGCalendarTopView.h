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

/**
 初始化方法

 @param type 控件起始类型
 @param index 默认选中下标
 @return 控件
 */
- (instancetype)initWithCalendarStartType:(SGCalendarStartType)type selectIndex:(NSInteger)index;

/**
 供子类继承使用
 */
- (void)createView;

/**
 更新最大最小日期

 @param maxDate 最大日期
 @param minDate 最小日期
 */
- (void)updateMaxDate:(NSDate *)maxDate minDate:(NSDate *)minDate;

/**
 是否显示 标题栏 (默认显示)
 
 @param show 是否显示
 @param animated 是否需要动画
 */
- (void)showTitleView:(BOOL)show animated:(BOOL)animated;

/**
 是否显示 日期切换 (内部逻辑: 切换总时, 隐藏日期切换)
 
 @param show 是否显示
 @param animated 是否需要动画
 */
- (void)showDateControlView:(BOOL)show animated:(BOOL)animated;


/**
 配置当前选中的下标和日期  会回调一次代理函数

 @param index 选中的下标
 @param date 选中的日期
 */
- (void)configSelectIndex:(NSInteger)index currentDate:(NSDate *)date;

@end
