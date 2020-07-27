//
//  DataSourceMager.h
//  MVP
//
//  Created by guoruize on 2020/6/22.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^CellConfigureBefore) (id _Nonnull cell, id _Nonnull model, NSIndexPath  * _Nonnull indexPath);
typedef void (^selectCell)(NSIndexPath * _Nonnull indexPath);

NS_ASSUME_NONNULL_BEGIN

@interface DataSourceMager : NSObject<
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource
>

- (instancetype)initWithIdentifier:(NSString *)reuseID configureBlock:(CellConfigureBefore)beforeBlock selectBlock:(selectCell)selectBlock;

- (void)addDataArray:(NSArray *)datas;

@end

NS_ASSUME_NONNULL_END
