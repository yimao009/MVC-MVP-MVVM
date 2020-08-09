//
//  PHAsset+FetchImage.h
//  StandMVC
//
//  Created by guoruize on 2020/8/7.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset (FetchImage)

- (UIImage *)fi_fastFullScreenImage;

- (UIImage *)fi_aspectThumbnailImageWithSize:(CGSize)size;

- (UIImage *)fi_aspectFillImageWithSize:(CGSize)size;


@end

NS_ASSUME_NONNULL_END
