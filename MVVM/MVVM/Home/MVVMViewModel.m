//
//  MVVMViewModel.m
//  MVVM
//
//  Created by guoruize on 2020/7/12.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "MVVMViewModel.h"
#import <ReactiveObjC.h>
@implementation MVVMViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        // block 反向 -- 响应式 KVO
        // MVP MVC MVVM
        // 嵌套层深 block 调试 安全 清晰度 MVP（面向协议）
//        [self addObserver:self forKeyPath:@"contentKey" options:NSKeyValueObservingOptionNew context:NULL];
        [RACObserve(self, contentKey) subscribeNext:^(id  _Nullable x) {
            NSArray *array = @[
                       @"转账", @"信用卡", @"充值中心", @"蚂蚁借呗", @"电影票",
                       @"滴滴出行", @"城市服务", @"蚂蚁森林"
                   ];
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:array];
            [mArr removeObject:x];
            if (self.successBlock) {
                self.successBlock(mArr.copy);
            }
        }];
    }
    return self;
}


- (void)loadData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        [NSThread sleepForTimeInterval:1];
        NSArray *array = @[
            @"转账", @"信用卡", @"充值中心", @"蚂蚁借呗", @"电影票",
            @"滴滴出行", @"城市服务", @"蚂蚁森林"
        ];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.successBlock) {
                self.successBlock(array);
            }
        });
    });
}

#pragma mark - KVO回调
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    NSString *contentKey = change[NSKeyValueChangeNewKey];
//    NSArray *array = @[
//               @"转账", @"信用卡", @"充值中心", @"蚂蚁借呗", @"电影票",
//               @"滴滴出行", @"城市服务", @"蚂蚁森林"
//           ];
//    NSMutableArray *mArr = [NSMutableArray arrayWithArray:array];
//    [mArr removeObject:contentKey];
//
//    if (self.successBlock) {
//        self.successBlock(mArr.copy);
//    }
//}
//
//- (void)dealloc
//{
//    [self removeObserver:self forKeyPath:@"contentKey"];
//}
@end
