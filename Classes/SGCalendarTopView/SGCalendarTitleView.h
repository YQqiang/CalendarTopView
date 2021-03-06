//
//  SGCalendarTitleView.h
//  CalendarTopView
//
//  Created by sungrow on 2018/8/13.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGCalendarTitleView;

@protocol SGCalendarTitleViewDelegate<NSObject>

- (void)calendarTitleView:(SGCalendarTitleView *)titleView didSelectedIndex:(NSInteger)index;

@end

@interface SGCalendarTitleView : UIView

@property (nonatomic, weak) id <SGCalendarTitleViewDelegate>delegate;

/**
 菜单名称数组
 */
@property(nonatomic,copy) NSArray <NSString *>*titleArray;

/**
 选中菜单时的文字颜色
 */
@property(nonatomic,strong) UIColor *selectedColor;

/**
 未选中菜单的文字颜色
 */
@property(nonatomic,strong) UIColor *noSlectedColor;

/**
 文字的字体
 */
@property(nonatomic,strong) UIFont *titleFont;

/**
 下划线的颜色
 */
@property(nonatomic,strong) UIColor *lineColor;

/**
 当前选中的索引值
 */
@property (nonatomic, assign) NSInteger currentIndex;

/**
 当值为 true 时: 点击相同的index, 会调用代理 didSelectedIndex:
 当值为 false 时: 点击相同的index, 不会调用代理
 默认值为 false
 */
@property (nonatomic, assign) BOOL forceSelectedIndex;

/**
 修改选中的下标

 @param index 下标
 */
- (void)curSelectedIndex:(NSInteger)index;

@end
