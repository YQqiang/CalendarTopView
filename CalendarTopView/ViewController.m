//
//  ViewController.m
//  CalendarTopView
//
//  Created by sungrow on 2018/8/13.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import "ViewController.h"
#import "SGCalendarTopView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    SGCalendarTopView *calendarView = [[SGCalendarTopView alloc] initWithCalendarStartType:CalendarStartDay selectIndex:3];
    [self.view addSubview:calendarView];
    calendarView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    calendarView.translatesAutoresizingMaskIntoConstraints = NO;
    [calendarView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:22].active = YES;
    [calendarView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [calendarView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
