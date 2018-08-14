//
//  DemoViewController.m
//  CalendarTopView
//
//  Created by sungrow on 2018/8/14.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import "DemoViewController.h"
#import "SGCalendarTopView.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    SGCalendarTopView *calendarView = [[SGCalendarTopView alloc] initWithCalendarStartType:CalendarStartDay selectIndex:0];
    [self.view addSubview:calendarView];
    calendarView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    calendarView.translatesAutoresizingMaskIntoConstraints = NO;
    [calendarView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:0].active = YES;
    [calendarView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [calendarView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
