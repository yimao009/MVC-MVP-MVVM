//
//  MyCameraViewController.h
//  StandMVC
//
//  Created by guoruize on 2020/8/2.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyCameraViewController;
@protocol MyCameraViewControllerDelegate <NSObject>

@optional
- (void)cameraViewController:(MyCameraViewController *)controller imageCaptured:(UIImage *)image;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MyCameraViewController : UIViewController

@property (nonatomic, weak) id<MyCameraViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
