//
//  CameraViewController.m
//  StandMVC
//
//  Created by guoruize on 2020/8/2.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface CameraViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (nonatomic, strong, readwrite) UIImagePickerController *pickerVC;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"相机相册";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)takePhotoAction2
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.delegate = self;
        vc.sourceType = UIImagePickerControllerSourceTypeCamera;
        vc.showsCameraControls = NO;
        
        UIView *controlView = [[UIView alloc] initWithFrame:self.view.bounds];
        UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [controlView addSubview:takePhotoBtn];
        takePhotoBtn.frame = CGRectMake((CGRectGetWidth(controlView.bounds) - 120) / 2, CGRectGetHeight(controlView.bounds) - 50 - 30, 120, 50);
        [takePhotoBtn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
        [takePhotoBtn setTitle:@"take Photo" forState:UIControlStateNormal];
        takePhotoBtn.backgroundColor = [UIColor grayColor];
        
        vc.cameraOverlayView = controlView;
        vc.mediaTypes = @[(__bridge_transfer NSString *)kUTTypeImage];
        vc.allowsEditing = YES;
        
        vc.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        vc.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        vc.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        self.pickerVC = vc;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)takePhoto
{
    [self.pickerVC takePicture];
}

- (IBAction)takePhotoAction:(id)sender {
    [self takePhotoAction2];
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
//        vc.delegate = self;
//        vc.sourceType = UIImagePickerControllerSourceTypeCamera;
//        vc.mediaTypes = @[(__bridge_transfer NSString *)kUTTypeImage];
//        vc.allowsEditing = YES;
//        [self presentViewController:vc animated:YES completion:nil];
//    }
}

- (IBAction)takeVideoAction:(id)sender {
    [self takeVideoAction2];
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
//        vc.delegate = self;
//        vc.sourceType = UIImagePickerControllerSourceTypeCamera;
//        vc.mediaTypes = @[(__bridge_transfer NSString *)kUTTypeMovie, (__bridge_transfer NSString *)kUTTypeImage];
//        vc.allowsEditing = YES;
//        [self presentViewController:vc animated:YES completion:nil];
//    }
}

- (void)takeVideoAction2
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.delegate = self;
        vc.sourceType = UIImagePickerControllerSourceTypeCamera;
        vc.mediaTypes = @[ (__bridge_transfer NSString *)kUTTypeImage, (__bridge_transfer NSString *)kUTTypeMovie];
        vc.allowsEditing = YES;
        vc.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo; // 设置进入拍照视频页面默认选择的设备
        vc.videoMaximumDuration = 0.5f;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (IBAction)showPhotoAction:(id)sender {
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.delegate = self;
    vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    vc.mediaTypes = @[(__bridge_transfer NSString *)kUTTypeImage];
    vc.allowsEditing = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)showVideoAction:(id)sender {
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.delegate = self;
//    vc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    vc.mediaTypes = @[(__bridge_transfer NSString *)kUTTypeMovie];
    vc.allowsEditing = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    NSLog(@"cancel");
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(__bridge_transfer NSString *)kUTTypeImage])
    {
        UIImage *editedImage = info[UIImagePickerControllerEditedImage];
        UIImage *originImage = info[UIImagePickerControllerOriginalImage];
        [self.selectedImageView setImage:editedImage];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(originImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    } else if([info[UIImagePickerControllerMediaType] isEqualToString:(__bridge_transfer NSString *)kUTTypeMovie]) {
        // 处理视频
        NSString *path = [info[UIImagePickerControllerMediaURL] path];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        NSLog(@"saved photo fail");
    } else
    {
        NSLog(@"saved photo succ");
    }
}

 - (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        NSLog(@"saved video fail");
    } else
    {
        NSLog(@"saved video succ");
    }
}
@end
