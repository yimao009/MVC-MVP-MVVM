//
//  GoodsViewModel.h
//  MVVM
//
//  Created by guoruize on 2020/8/23.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 商品首页视图模型
@interface GoodsViewModel : NSObject

/// banners
@property (nonatomic, strong, readonly) NSArray <NSString *>*banners;
/// the data source of table view
@property (nonatomic, strong, readwrite) NSMutableArray *dataSource;

/// load banners data
/// @param success <#success description#>
/// @param failure <#failure description#>
- (void)loadBannerData:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/// 加载网络数据 通过block回调减轻view对viewModel的状态监听
/// @param json <#json description#>
/// @param failure <#failure description#>
/// @param configFooter <#configFooter description#>
- (void)loadData:(void (^)(id json))json
         failure:(void(^)(NSError *error))failure
    configFooter:(void(^)(BOOL isLastPage))configFooter;
@end

NS_ASSUME_NONNULL_END
