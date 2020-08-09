//
//  MyImagePickAlbumsTableViewController.h
//  StandMVC
//
//  Created by guoruize on 2020/8/6.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAssetCollection;
@class MyImagePickAlbumsTableViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol MyImagePickAlbumsTableViewControllerDelegate <NSObject>

@optional
- (void)imagePickAAlbumsViewController:(MyImagePickAlbumsTableViewController *)imagePickAlbumsViewcController didSelectAlbum:(PHAssetCollection *)album;

@end

/// 选择相册列表界面
@interface MyImagePickAlbumsTableViewController : UITableViewController

@property (nonatomic, weak) id<MyImagePickAlbumsTableViewControllerDelegate> delegate;

- (instancetype)initWithAssetCollections:(NSArray<PHAssetCollection *> *)assetCollections;

@end

NS_ASSUME_NONNULL_END
