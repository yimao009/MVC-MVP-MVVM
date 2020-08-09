//
//  PHAsset+FetchImage.m
//  StandMVC
//
//  Created by guoruize on 2020/8/7.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "PHAsset+FetchImage.h"
#import <UIKit/UIKit.h>
@implementation PHAsset (FetchImage)
- (UIImage *)fi_fastFullScreenImage
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    __block UIImage *image = nil;
    [[PHImageManager defaultManager] requestImageForAsset:self
                                               targetSize:CGSizeMake(screenSize.width * scale, screenSize.height * scale)
                                              contentMode:PHImageContentModeAspectFit
                                                  options:options
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        image = result;
    }];
    return image;
}

- (UIImage *)fi_aspectThumbnailImageWithSize:(CGSize)size
{
    CGSize targetSize = size;
    CGFloat side = MIN(targetSize.width, targetSize.height);
    CGFloat ratio = 360 / side; //thumbnail大小取360为上限是处于同步取图的性能考虑
    if (ratio < 1)
    {
        targetSize.width = targetSize.width * ratio;
        targetSize.height = targetSize.height * ratio;
    }
    return [self fi_aspectFillImageWithSize:targetSize];
}


- (UIImage *)fi_aspectFillImageWithSize:(CGSize)size
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    CGSize targetSize = size;
    CGSize imageSize = CGSizeMake(self.pixelWidth, self.pixelHeight);
    if (targetSize.width >= imageSize.width && targetSize.height >= imageSize.height)
    {
        // 禁止小图拉大
        targetSize = imageSize;
    }
    __block UIImage *img;
    [[PHImageManager defaultManager] requestImageForAsset:self
                                               targetSize:targetSize
                                              contentMode:PHImageContentModeAspectFill
                                                  options:options
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        img = result;
    }];
    return img;
}
@end
