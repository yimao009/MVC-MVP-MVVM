//
//  MyImagePreviewViewController.m
//  StandMVC
//
//  Created by guoruize on 2020/8/9.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "MyImagePreviewViewController.h"
#import "PHAsset+FetchImage.h"
@interface MyImagePreviewViewController ()
{
    UIImageView *_imageView;
}
@end

@implementation MyImagePreviewViewController

- (instancetype)initWithAsset:(PHAsset *)asset
{
    if (self = [self initWithNibName:nil bundle:nil])
    {
        _asset = asset;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(selectAction:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.image = [_asset fi_fastFullScreenImage];
    [self.view addSubview:_imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _imageView.frame = self.view.bounds;
}

#pragma mark - actions
- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePreviewViewController:)])
    {
        [self.delegate imagePreviewViewController:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
}
@end
