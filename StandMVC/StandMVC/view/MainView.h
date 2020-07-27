//
//  MainView.h
//  MVCDemo
//
//  Created by guoruize on 2020/5/30.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN



@interface MainView : UIView

// 通过target-action方式对外提供交互
@property (nonatomic, strong, readwrite) UIButton *btn1;
@property (nonatomic, strong, readwrite) UIButton *btn2;

@end

NS_ASSUME_NONNULL_END
