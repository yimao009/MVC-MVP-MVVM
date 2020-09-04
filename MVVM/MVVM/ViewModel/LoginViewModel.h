//
//  LoginViewModel.h
//  MVVM
//
//  Created by guoruize on 2020/8/23.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 登陆界面的视图模型 -- VM
@interface LoginViewModel : NSObject
/// 手机号
@property (nonatomic, copy, readwrite) NSString *mobilePhone;
/// 验证码
@property (nonatomic, copy, readwrite) NSString *verifyCode;
/// 登陆按钮点击的状态
@property (nonatomic, assign, readonly) BOOL *valildLogin;
/// 用户头像
@property (nonatomic, copy, readonly) NSString *avatarUrlString;

/// 用户登陆 为了减少view对viewModel的状态监听， 这里采用block回调来减少状态管理
/// @param success <#success description#>
/// @param failure <#failure description#>
- (void)loginSuccess:(void(^)(id json))success failure:(void(^)(NSError *error))failure;

- (instancetype)initWithParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
