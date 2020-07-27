//
//  ToDoStore.m
//  StandMVC
//
//  Created by guoruize on 2020/7/19.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "ToDoStore.h"

@interface ChangeBehaviorModel ()
@property (nonatomic, assign, readwrite) ChangeBehavior bghavior;
@property (nonatomic, strong, readwrite) NSArray *tmpIndexs;

@end

@implementation ChangeBehaviorModel

- (instancetype)initWithBehavior:(ChangeBehavior)behavior indexs:(NSArray *)indexs
{
    if (self = [super init]) {
        _bghavior = behavior;
        _tmpIndexs = indexs;
    }
    return self;
}

@end


static ToDoStore *instance = nil;
@interface ToDoStore ()
@property (nonatomic, strong, readwrite) NSMutableArray <ToDoItem *> *items;
@property (nonatomic, strong, readwrite) NSMutableDictionary *info;
@end

@implementation ToDoStore
@synthesize items = _items;
+ (ToDoStore *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ToDoStore alloc] init];
    });
    return instance;
}

- (void)append:(ToDoItem *)item
{
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.items];
    [tmpArr addObject:item];
    self.items = tmpArr;
}

- (void)appendWithItems:(NSArray<ToDoItem *> *)items
{
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.items];
    [tmpArr addObjectsFromArray:items];
    self.items = tmpArr;
}

- (void)remove:(ToDoItem *)item
{
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.items];
    [tmpArr removeObject:item];
    self.items = tmpArr;
}

- (void)removeWithIndex:(NSInteger)index
{
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.items];
    [tmpArr removeObjectAtIndex:index];
    self.items = tmpArr;
}

- (void)editOldItem:(ToDoItem *)original newItem:(ToDoItem *)newItem
{
    NSUInteger index = [self.items indexOfObject:original];
    if (index == NSNotFound) {
        return;
    }
    self.items[index] = newItem;
}

- (ToDoItem *)itemAtIndex:(NSInteger)index
{
    if (index < 0 && index > self.count) {
       return nil;
    }
    return self.items[index];
}

- (NSInteger)count
{
    return self.items.count;
}

- (ChangeBehaviorModel *)diffOriginal:(NSArray<ToDoItem *> *)original now:(NSArray<ToDoItem *> *)now
{
    NSMutableSet *originalSet = [NSMutableSet setWithArray:original];
    NSMutableSet *nowSet = [[NSMutableSet alloc] initWithArray:now];
    ChangeBehaviorModel *behaviorModel = nil;
    if ([originalSet isSubsetOfSet:nowSet])
    {
        // Appended
        [nowSet minusSet:originalSet];
        NSMutableArray *indexArr = [@[] mutableCopy];
        for (ToDoItem *obj in nowSet) {
            NSUInteger index = [now indexOfObject:obj];
            [indexArr addObject:@(index)];
        }
        behaviorModel = [[ChangeBehaviorModel alloc] initWithBehavior:add indexs:indexArr];
    }
    else if([nowSet isSubsetOfSet:originalSet])
    {
        // removed
        [originalSet minusSet:nowSet];
        NSMutableArray *indexArr = [@[] mutableCopy];
        for (ToDoItem *obj in originalSet) {
            NSUInteger index = [original indexOfObject:obj];
            [indexArr addObject:@(index)];
        }
        behaviorModel = [[ChangeBehaviorModel alloc] initWithBehavior:removed indexs:indexArr];
    }
    else
    {
        behaviorModel = [[ChangeBehaviorModel alloc] initWithBehavior:reload indexs:@[]];
    }
    return behaviorModel;
}

- (NSMutableArray<ToDoItem *> *)items
{
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

- (void)setItems:(NSMutableArray<ToDoItem *> *)items
{
    
    ChangeBehaviorModel *info = [self diffOriginal:_items now:items];
    _items = items;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kTodoStoreDidChangedNotificationName" object:self userInfo:@{@"userInfo":info}];
}

- (NSMutableDictionary *)info
{
    if (!_info) {
        _info = [[NSMutableDictionary alloc] init];
    }
    return _info;
}



@end
