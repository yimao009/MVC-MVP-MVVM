//
//  WKWebViewDemoController.m
//  StandMVC
//
//  Created by guoruize on 2020/8/30.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "WKWebViewDemoController.h"
#import "WKBaseUSEViewController.h"
@interface WKWebViewDemoController ()

@end

@implementation WKWebViewDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
// WKWebView基础使用
- (IBAction)wkBasicUseButtonClicked:(id)sender {
    [self.navigationController pushViewController:[[WKBaseUSEViewController alloc] init] animated:YES];
}

// 自定义WKWebView显示内容
- (IBAction)customWKWebViewButtonClicked:(id)sender {
    
}

@end
