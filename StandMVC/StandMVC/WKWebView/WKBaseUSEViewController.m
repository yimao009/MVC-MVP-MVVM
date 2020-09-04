//
//  WKBaseUSEViewController.m
//  StandMVC
//
//  Created by guoruize on 2020/8/30.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "WKBaseUSEViewController.h"
#import <WebKit/WebKit.h>
#import "QiWKDetailViewController.h"
@interface WKBaseUSEViewController ()
@property (nonatomic, strong, readwrite) WKWebView *wkWebView;
@end

@implementation WKBaseUSEViewController

- (void)loadView
{
    WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc] init];
    if (@available(iOS 10.0, *)) {
        conf.dataDetectorTypes = WKDataDetectorTypePhoneNumber;
    } else {
        // Fallback on earlier versions
    }
    _wkWebView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:conf];
        // 允许左滑右滑手势
//    _wkWebView.allowsBackForwardNavigationGestures = YES;
    _wkWebView.backgroundColor = [UIColor whiteColor];
    self.view =  _wkWebView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
}

- (void)setupUI
{
    self.title = @"WKWebView基本使用";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(moreItemClicked:)];

    CGFloat toolBarH = 44;
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.barTintColor = [UIColor lightGrayColor];
    CGFloat bottom = [[UIApplication sharedApplication].windows firstObject].safeAreaInsets.bottom;
    toolBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - toolBarH - bottom, CGRectGetWidth(self.view.frame), toolBarH);
    [self.view addSubview:toolBar];
    
    UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc] initWithTitle:@"forward" style:UIBarButtonItemStyleDone target:self action:@selector(forwardButtonClicked:)];
    UIBarButtonItem *backwardItem = [[UIBarButtonItem alloc] initWithTitle:@"backward" style:UIBarButtonItemStyleDone target:self action:@selector(backwardButtonClicked:)];
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithTitle:@"refresh" style:UIBarButtonItemStyleDone target:self action:@selector(refreshButtonClicked:)];
    UIBarButtonItem *backforwardListItem = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStyleDone target:self action:@selector(backforwardListItemClicked:)];
    UIBarButtonItem *snapItem = [[UIBarButtonItem alloc] initWithTitle:@"snap" style:UIBarButtonItemStyleDone target:self action:@selector(snapItemClicked:)];
    
    toolBar.items = @[forwardItem, backwardItem, refreshItem, backforwardListItem, snapItem];
    
    NSString *urlStr = @"https://www.so.com";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_wkWebView loadRequest:request];
}

#pragma mark - Actions
- (void)forwardButtonClicked:(UIBarButtonItem *)sender
{
    if ([_wkWebView canGoForward]) {
        [_wkWebView goForward];
    }
}

- (void)backwardButtonClicked:(UIBarButtonItem *)sender
{
    if ([_wkWebView canGoBack]) {
        [_wkWebView goBack];
    }
}

- (void)refreshButtonClicked:(UIBarButtonItem *)sender
{
    [_wkWebView reload];
}
- (void)backforwardListItemClicked:(UIBarButtonItem *)sender
{
    if (_wkWebView.backForwardList.forwardList.count > 0) {
         NSLog(@"forwardItem");
         NSLog(@"title：%@", _wkWebView.backForwardList.forwardItem.title);
         NSLog(@"URL：%@", _wkWebView.backForwardList.forwardItem.URL);
    }
    if (_wkWebView.backForwardList.backList.count > 0) {
         NSLog(@"backForwardItem");
         NSLog(@"title：%@", _wkWebView.backForwardList.backItem.title);
         NSLog(@"URL：%@", _wkWebView.backForwardList.backItem.URL);
    }
}
- (void)snapItemClicked:(UIBarButtonItem *)sender
{
    if (@available(iOS 11.0, *)) {
        WKSnapshotConfiguration *snapConfig = [[WKSnapshotConfiguration alloc] init];
        [_wkWebView takeSnapshotWithConfiguration:snapConfig completionHandler:^(UIImage * _Nullable snapshotImage, NSError * _Nullable error) {
            UIImageWriteToSavedPhotosAlbum(snapshotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];
    } else {
        // Fallback on earlier versions
    }
  
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSString *msg = nil;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    NSLog(@"%@", msg);
}

- (void)moreItemClicked:(UIBarButtonItem *)sender {
    
    QiWKDetailViewController *detailVC = [QiWKDetailViewController new];
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
