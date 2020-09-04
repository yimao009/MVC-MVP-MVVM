//
//  LoginInputView.h
//  MVVM
//
//  Created by guoruize on 2020/8/23.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginInputView : UIView

/// 手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

/// 验证码
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;

+ (instancetype) inputView;

@end

NS_ASSUME_NONNULL_END
