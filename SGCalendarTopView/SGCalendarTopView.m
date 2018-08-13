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

@interface SGCalendarTopView ()

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

@end

@implementation SGCalendarTopView

#pragma mark - lazy

- (SGCalendarTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[SGCalendarTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        _titleView.backgroundColor = [UIColor redColor];
    }
    return _titleView;
}

- (SGCalendarControlView *)dateControlView {
    if (!_dateControlView) {
        _dateControlView = [[SGCalendarControlView alloc] init];
    }
    return _dateControlView;
}


#pragma mark - init

- (instancetype)init {
    if (self = [super init]) {
        [self createView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createView];
}

#pragma mark - view
- (void)createView {
    // TODO: 测试代码
    self.calendarStartType = CalendarStartMonth;
    self.selectIndex = 2;
    
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
    [self.dateControlView.heightAnchor constraintEqualToConstant:44].active = YES;
}

#pragma mark - action

@end
