//
//  CustomAlbumViewController.m
//  StandMVC
//
//  Created by guoruize on 2020/8/4.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "CustomAlbumViewController.h"
#import "MyImagePickerViewController.h"
#import "PHAsset+FetchImage.h"
@interface CustomAlbumViewController ()<MyImagePickerViewControllerDelegate>
{
    NSMutableArray <UIImageView *>* _imageViews;
}
@end

@implementation CustomAlbumViewController

- (void)loadView
{
    [super loadView];
    // 创建四个ImageView 展示对象
    CGFloat width   = self.view.bounds.size.width / 2;
    CGFloat height  = self.view.bounds.size.height / 2;
    _imageViews = [NSMutableArray array];
    for (int i = 0; i < 2; i++)
    {
        for (int j = 0; j < 2; j++)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(j * width, i * height, width, height);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"MyImagePickerDemo";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Pick" style:UIBarButtonItemStylePlain target:self action:@selector(pickAction:)];
}

- (void)pickAction:(id)sender
{
    MyImagePickerViewController *picker = [[MyImagePickerViewController alloc] init];
    picker.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - MyImagePickerViewController
- (void)imagePickerViewController:(MyImagePickerViewController *)imagePickerViewController didSelectAssets:(NSArray<PHAsset *> *)assets
{
    [_imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.image = nil;
    }];
    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > _imageViews.count)
        {
            *stop = YES;
        }
        _imageViews[idx].image = [obj fi_fastFullScreenImage];
    }];
}

@end
