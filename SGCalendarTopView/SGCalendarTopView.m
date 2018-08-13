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
    [self addSubview:self.titleView];
    self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.titleView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.titleView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.titleView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.titleView.heightAnchor constraintEqualToConstant:44].active = YES;
    
    self.titleView.selectedColor = [UIColor blueColor];
    self.titleView.noSlectedColor = [UIColor blackColor];
    self.titleView.titleArray = @[@"日", @"月", @"年", @"总"];
    self.titleView.currentIndex = 0;
    
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
