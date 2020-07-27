//
//  MainView.h
//  MVCDemo
//
//  Created by guoruize on 2020/5/30.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainView;


NS_ASSUME_NONNULL_BEGIN

@protocol MainViewDelegate <NSObject>

@required

@optional
- (void)mainView:(MainView *)mainView loadStr:(NSString *)str;

@end

@interface MainView : UIView

@property (nonatomic, strong, readwrite) UIButton *btn1;
@property (nonatomic, strong, readwrite) UIButton *btn2;


@property (nonatomic, strong, readwrite) void (^saveBlock)(void);
@property (nonatomic, weak, readwrite) id<MainViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
