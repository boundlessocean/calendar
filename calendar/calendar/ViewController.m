//
//  ViewController.m
//  calendar
//
//  Created by boundlessocean on 2017/9/24.
//  Copyright © 2017年 lemon. All rights reserved.
//

#import "ViewController.h"
#import "BLCalendarViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self showCalendar];
}

// 显示日历
- (void)showCalendar{
    BLCalendarViewController *calendar = [BLCalendarViewController new];
    calendar.callBackSelectedDate = ^(BLCalendarModel *model) {
       // Handle call back data model
        
    };
    calendar.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:calendar animated:NO completion:nil];
}

@end
