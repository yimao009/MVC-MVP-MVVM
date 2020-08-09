//
//  MyImagePreviewViewController.h
//  StandMVC
//
//  Created by guoruize on 2020/8/9.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAsset;
@class MyImagePreviewViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol MyImagePreviewViewControllerDelegate<NSObject>

@optional
- (void)imagePreviewViewController: (MyImagePreviewViewController *)imagePreviewViewController;

@end


@interface MyImagePreviewViewController : UIViewController

@property (nonatomic, weak) id<MyImagePreviewViewControllerDelegate> delegate;

- (instancetype)initWithAsset:(PHAsset *)asset;

@property (nonatomic, strong, readonly) PHAsset *asset;

@end

NS_ASSUME_NONNULL_END
