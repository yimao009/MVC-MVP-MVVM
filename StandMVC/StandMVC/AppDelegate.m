//
//  AppDelegate.m
//  StandMVC
//
//  Created by guoruize on 2020/6/17.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSUserDefaults *userDefulats = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.exam.StandMVC"];
    [userDefulats setValue:@"hello" forKey:@"title"];
    NSString *title = [userDefulats objectForKey:@"newkey"];
    NSLog(@"%@", title);

    return YES;
}


#pragma mark - UISceneSession lifecycle

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
//{
//        NSLog(@"%@",url);
//    return YES;
//}
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//        NSLog(@"%@",url);
//    return YES;
//}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSURL *fileURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.exam.StandMVC"];
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.exam.StandMVC"];
    NSString *title = [userDefaults objectForKey:@"newkey"];
    NSArray *array = [userDefaults objectForKey:@"ShareDataKey"];
    NSDictionary *dict = [array firstObject];
    NSData *imgData = dict[@"imgData"];
    NSString *urlStr = dict[@"URL"];
    NSString *name = dict[@"name"];
//    NSString *imgStr = dict[@"imgStr"];
    NSError *error = nil;
    NSURL *url1 = [NSURL URLWithString:urlStr];
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr] options:NSDataReadingMappedIfSafe error:&error];
    if (error) {
        NSLog(@"err %@", error);
    }
//    NSData *data2 = [NSData dataWithContentsOfFile:urlStr];
//    UIImage *img2 = [self Base64StrToUIImage:imgStr];
    UIImage *img = [UIImage imageWithData:imgData];
    NSLog(@"%@", title);
    NSLog(@"%@",options);
    return YES;
}

//字符串转图片
- (UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr
{
    NSData *_decodedImageData = [[NSData alloc] initWithBase64Encoding:_encodedImageStr];
    UIImage *_decodedImage = [UIImage imageWithData:_decodedImageData];
    return _decodedImage;
}
@end
