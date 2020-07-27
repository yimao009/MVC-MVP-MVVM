//
//  ToDoStore.h
//  StandMVC
//
//  Created by guoruize on 2020/7/19.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ToDoItem;

typedef NS_ENUM(NSUInteger, ChangeBehavior) {
    add,
    removed,
    reload,
};

NS_ASSUME_NONNULL_BEGIN

@interface ChangeBehaviorModel : NSObject
- (instancetype)initWithBehavior:(ChangeBehavior)behavior indexs:(NSArray *)indexs;
@property (nonatomic, assign, readonly) ChangeBehavior bghavior;
@property (nonatomic, strong, readonly) NSArray *tmpIndexs;
@end


//extern NSString * const kTodoStoreDidChangedNotificationName = @"kTodoStoreDidChangedNotificationName";
//NSString * _Nonnull const kTodoStoreDidChangedNotificationName = @"kTodoStoreDidChangedNotificationName";



@interface ToDoStore : NSObject

+ (ToDoStore *)sharedInstance;

- (void)append:(ToDoItem *)item;
- (void)appendWithItems:(NSArray<ToDoItem *> *)items;

- (void)remove:(ToDoItem *)item;
- (void)removeWithIndex:(NSInteger)index;

- (void)editOldItem:(ToDoItem *)original newItem:(ToDoItem *)newItem;

- (ToDoItem *)itemAtIndex:(NSInteger)index;

// 网络请求的接口

@property (nonatomic, assign, readonly) NSInteger count;

- (ChangeBehaviorModel *)diffOriginal:(NSArray<ToDoItem *> *)original now:(NSArray<ToDoItem *> *)now;


@end

NS_ASSUME_NONNULL_END
