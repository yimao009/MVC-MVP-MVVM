//
//  BaseViewModel.h
//  MVVM
//
//  Created by guoruize on 2020/7/12.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock) (id _Nullable data);
typedef void(^failBlock) (id _Nullable data);


NS_ASSUME_NONNULL_BEGIN

@interface BaseViewModel : NSObject

@property (nonatomic, copy, readwrite) successBlock successBlock;
@property (nonatomic, copy, readwrite) failBlock failBlock;

- (void)initWithBlock:(_Nullable successBlock)successBlock fail:(_Nullable failBlock)failBlock;
@end

NS_ASSUME_NONNULL_END
