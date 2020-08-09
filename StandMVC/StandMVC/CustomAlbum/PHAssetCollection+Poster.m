//
//  PHAssetCollection+Poster.m
//  StandMVC
//
//  Created by guoruize on 2020/8/9.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "PHAssetCollection+Poster.h"
#import "PHAsset+FetchImage.h"
#import <UIKit/UIKit.h>
@implementation PHAssetCollection (Poster)
- (UIImage *)pi_poster
{
    return [self pi_posterWithSize:CGSizeMake(75, 75)];
}
- (UIImage *)pi_posterWithSize:(CGSize)size
{
    CGFloat scale = [UIScreen mainScreen].scale;
    PHAsset *asset = [[PHAsset fetchKeyAssetsInAssetCollection:self options:nil] firstObject];
    UIImage *poster = [asset fi_aspectThumbnailImageWithSize:CGSizeMake(size.width * scale, size.height * scale)];
    return poster;
}
@end
