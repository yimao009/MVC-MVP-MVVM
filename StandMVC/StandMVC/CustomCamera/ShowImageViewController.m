//
//  ShowImageViewController.m
//  StandMVC
//
//  Created by guoruize on 2020/8/2.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "ShowImageViewController.h"
#import "MyCameraViewController.h"
@interface ShowImageViewController ()<MyCameraViewControllerDelegate>
{
    @private
    UIImageView *_imageView;
}
@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"MyImagePickerDemo";
    
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_imageView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"TakePhoto" style:UIBarButtonItemStylePlain target:self action:@selector(takeAction:)];
}

- (void)takeAction:(id)sender
{
    MyCameraViewController *takePhoto = [[MyCameraViewController alloc] init];
    takePhoto.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:takePhoto];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - MyCameraViewControllerDelegate
- (void)cameraViewController:(MyCameraViewController *)controller imageCaptured:(UIImage *)image
{
    _imageView.image = image;
}
@end
