//
//  Present.h
//  MVP
//
//  Created by guoruize on 2020/6/22.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit.h>
@protocol PresentDelegate <NSObject>

@optional
- (void)reloadDataForUI;
- (void)didClickNum: (NSString *_Nullable)numStr indexPath:(NSIndexPath * _Nullable)indexPath;
@end

// cell <--> Model 通讯 双向
// 架构 需求 - 1接口 - 2代理三部曲 （写协议 遵循协议 实现协议）
// MVP 以需求驱动代码

// MVVM 以数据驱动代码
// 胶水代码很多 
// block --> MVVM
 
NS_ASSUME_NONNULL_BEGIN

@interface Present : NSObject<PresentDelegate>

@property (nonatomic, strong, readonly) NSMutableArray *dataArray;
@property (nonatomic, weak, readwrite) id<PresentDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
