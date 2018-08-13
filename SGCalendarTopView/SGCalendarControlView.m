//
//  SGCalendarControlView.m
//  CalendarTopView
//
//  Created by sungrow on 2018/8/13.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import "SGCalendarControlView.h"

@interface SGCalendarControlView ()

/**
 向前
 */
@property (nonatomic, strong) UIButton *previousButton;

/**
 日期
 */
@property (nonatomic, strong) UIButton *dateButton;

/**
 向后
 */
@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation SGCalendarControlView

#pragma mark - lazy
- (UIButton *)previousButton {
    if (!_previousButton) {
        _previousButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    }
    return _previousButton;
}

- (UIButton *)dateButton {
    if (!_dateButton) {
        _dateButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    }
    return _dateButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    }
    return _nextButton;
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
    [self addSubview:self.previousButton];
    self.previousButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.previousButton.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.previousButton.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.previousButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.previousButton.widthAnchor constraintEqualToConstant:80].active = YES;
    
    [self addSubview:self.nextButton];
    self.nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nextButton.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.nextButton.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.nextButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.nextButton.widthAnchor constraintEqualToAnchor:self.previousButton.widthAnchor].active = YES;
    
    [self addSubview:self.dateButton];
    self.dateButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dateButton.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.dateButton.rightAnchor constraintEqualToAnchor:self.nextButton.leftAnchor].active = YES;
    [self.dateButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.dateButton.leftAnchor constraintEqualToAnchor:self.previousButton.rightAnchor].active = YES;
}

#pragma mark - action

@end
