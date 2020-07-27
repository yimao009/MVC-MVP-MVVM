//
//  Present.m
//  MVP
//
//  Created by guoruize on 2020/6/22.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "Present.h"
#import "Model.h"

@interface Present ()
@property (nonatomic, strong, readwrite) NSMutableArray *dataArray;

@end

@implementation Present

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadData];
    }
    return self;
}

- (void)loadData
{
    NSArray *temArray =
    @[
#import "data.h"
    ];
    for (int i = 0; i<temArray.count; i++) {
        Model *m = [Model modelWithDictionary:temArray[i]];
        [self.dataArray addObject:m];
    }
}

#pragma mark - LAZY

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - PresentDelegate

- (void)didClickNum:(NSString *)numStr indexPath:(NSIndexPath *)indexPath
{
    // @synchronized 什么样的锁， 是否可以循环加锁？
    // 安全
    // 胶水代码
//    @synchronized (self) {
//        if (indexPath.row < self.dataArray.count) {
//            Model *model = self.dataArray[indexPath.row];
//            model.num    = numStr;
//        }
//    }
    
    
    if ([numStr intValue] > 5) {
        NSArray *tmpArr = @[
            @{@"name":@"CadsC",@"imageUrl":@"http://CC",@"num":@"9"},
            @{@"name":@"Jadsfes",@"imageUrl":@"http://James",@"num":@"69"},
            @{@"name":@"Gadsfin",@"imageUrl":@"http://Gavin",@"num":@"22"},
            @{@"name":@"adci",@"imageUrl":@"http://Cooci",@"num":@"9"},
            @{@"name":@"adn",@"imageUrl":@"http://Dean ",@"num":@"45"},
        ];
        
        [self.dataArray removeAllObjects];
        for (NSDictionary *dict in tmpArr) {
            Model *m = [Model modelWithDictionary:dict];
            [self.dataArray addObject:m];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadDataForUI)]) {
            [self.delegate reloadDataForUI];
        }
    }
}

@end
