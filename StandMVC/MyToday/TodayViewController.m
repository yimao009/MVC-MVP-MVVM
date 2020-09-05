//
//  TodayViewController.m
//  MyToday
//
//  Created by guoruize on 2020/9/4.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"打开" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(openapp) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(100, 0, 200, 200);
    
    [self.view addSubview:btn];
//    [self.view addSubview:{
//
//    }];
}
- (void)openapp
{
    [self.extensionContext openURL:[NSURL URLWithString:@"StandMVC://"] completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"success");
        }
        else
        {
            NSLog(@"failure");
        }
    }];
}
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
