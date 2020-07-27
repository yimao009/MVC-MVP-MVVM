//
//  DataSourceMager.m
//  MVP
//
//  Created by guoruize on 2020/6/22.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "DataSourceMager.h"

@interface DataSourceMager ()
@property (nonatomic, strong, readwrite) NSString *reuseID;
@property (nonatomic, copy, readwrite) CellConfigureBefore cellConfigureBefore;
@property (nonatomic, copy, readwrite) selectCell selectBlock;
@property (nonatomic, strong, readwrite) NSMutableArray *dataArray;
@end

@implementation DataSourceMager

- (instancetype)initWithIdentifier:(NSString *)reuseID configureBlock:(CellConfigureBefore)beforeBlock selectBlock:(selectCell)selectBlock
{
    self = [super init];
    if (self) {
        _reuseID = reuseID;
        _cellConfigureBefore = [beforeBlock copy];
        _selectBlock = [selectBlock copy];
    }
    return self;
}

- (void)addDataArray:(NSArray *)datas
{
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:datas];
}

- (id)modelsAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataArray.count > indexPath.row ? self.dataArray[indexPath.row] : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.reuseID forIndexPath:indexPath];
    id model = [self modelsAtIndexPath:indexPath];
    if (self.cellConfigureBefore) {
        self.cellConfigureBefore(cell, model, indexPath);
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return !self.dataArray ? 0 : self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlock) {
        self.selectBlock(indexPath);
    }
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:5];
    }
    return _dataArray;
}
@end
