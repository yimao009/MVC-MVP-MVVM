//
//  MVVMViewModel.h
//  MVVM
//
//  Created by guoruize on 2020/7/12.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MVVMViewModel : BaseViewModel
@property (nonatomic, copy)NSString * contentKey;

- (void)loadData;
@end

NS_ASSUME_NONNULL_END
