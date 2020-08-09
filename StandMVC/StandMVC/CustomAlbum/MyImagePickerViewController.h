//
//  MyImagePickerViewController.h
//  StandMVC
//
//  Created by guoruize on 2020/8/4.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;
@class MyImagePickerViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol MyImagePickerViewControllerDelegate <NSObject>
@optional
- (void)imagePickerViewController: (MyImagePickerViewController *)imagePickerViewController didSelectAssets:(NSArray<PHAsset *>*)assets;
@end

/// 展示某一个albums所有照片
@interface MyImagePickerViewController : UICollectionViewController
@property (nonatomic, weak) id<MyImagePickerViewControllerDelegate> delegate;
@property (nonatomic, strong, readwrite) PHAsset *asset;
@end

NS_ASSUME_NONNULL_END
