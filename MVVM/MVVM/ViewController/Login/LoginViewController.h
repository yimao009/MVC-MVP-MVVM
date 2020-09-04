//
//  LoginViewController.h
//  MVVM
//
//  Created by guoruize on 2020/8/23.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController
/// The `viewModel` parameter in `-initWithViewModel:` method.
@property (nonatomic, strong, readonly, nonnull) LoginViewModel *viewModel;

- (instancetype) initWithViewModel:(LoginViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
