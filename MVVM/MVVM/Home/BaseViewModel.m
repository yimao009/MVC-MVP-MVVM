//
//  BaseViewModel.m
//  MVVM
//
//  Created by guoruize on 2020/7/12.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel
- (void)initWithBlock:(successBlock)successBlock fail:(failBlock)failBlock
{
    _successBlock = successBlock;
    _failBlock = failBlock;
}
@end
