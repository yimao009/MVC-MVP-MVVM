//
//  LoginViewModel.m
//  MVVM
//
//  Created by guoruize on 2020/8/23.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "LoginViewModel.h"
#import <FBKVOController.h>
@interface LoginViewModel ()
@property (nonatomic, strong, readwrite) NSDictionary *params;
@end

@implementation LoginViewModel
{
    FBKVOController *_KVOController;
}
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super init]) {
        _params = params;
        
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [self addObserver:self
           forKeyPath:@"mobilePhone"
              options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
              context:NULL];
//    _KVOController = [FBKVOController controllerWithObserver:self];
//
//    [_KVOController observe:self keyPath:@"mobilePhone" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
//        NSLog(@"");
//    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
   
}

- (void)loginSuccess:(void(^)(id json))success failure:(void(^)(NSError *error))failure
{
    
}
@end
