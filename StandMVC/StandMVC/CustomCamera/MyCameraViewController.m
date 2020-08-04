//
//  MyCameraViewController.m
//  StandMVC
//
//  Created by guoruize on 2020/8/2.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "MyCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TestViewController.h"
@interface MyCameraViewController ()
{
    @private
    AVCaptureSession *_session;
    AVCaptureDeviceInput *_deviceInput;
    AVCaptureStillImageOutput *_imageOutPut;
    AVCaptureVideoPreviewLayer *_previewLayer;
    
    AVCaptureFlashMode _flashMode;
}
@property (nonatomic, assign, readwrite) AVCaptureFlashMode flashMode;

@end

@implementation MyCameraViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startCamera];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopCamera];
}
- (void)viewDidLoad {
    [super viewDidLoad];
        if (@available(iOS 10.0, *)) {
            NSLog(@"%@", [UIDevice currentDevice].systemVersion);
        } else {
            NSLog(@"%@", [UIDevice currentDevice].systemVersion);
        }
    //    if (__builtin_available(<#{i, mac, tv, watch}#>OS <#x.y.z#>, *)) {
    //        <#API available statements#>
    //    } else {
    //        <#fallback statements#>
    //    }
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Take" style:UIBarButtonItemStylePlain target:self action:@selector(takeAction:)];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    switchButton.frame = CGRectMake(0, 0, titleView.bounds.size.width/2, titleView.bounds.size.height);
    switchButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [switchButton setTitle:@"Switch" forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:switchButton];
    
    UIButton *flashhButton = [UIButton buttonWithType:UIButtonTypeSystem];
    flashhButton.frame = CGRectMake(titleView.bounds.size.width/2, 0, titleView.bounds.size.width/2, titleView.bounds.size.height);
    flashhButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [flashhButton setTitle:@"Flash" forState:UIControlStateNormal];
    [flashhButton addTarget:self action:@selector(flashAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:flashhButton];
    
    self.navigationItem.titleView = titleView;
    self.title = @"Camera";
    _flashMode = AVCaptureFlashModeAuto;
    [self requestAuthorization:^(BOOL granted) {
       // 主线程问题
        [self performSelectorOnMainThread:@selector(requestAuthorizationFinished:) withObject:@(granted) waitUntilDone:NO];
    }];
//    [AVCaptureDevice devices]
    
//    NSArray *arr = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[@(AVCaptureDeviceTypeBuiltInDualCamera)] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
}

#pragma mark - Permission
- (void)requestAuthorization:(void(^)(BOOL granted))handler
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:handler];
    }
    else if(handler)
    {
        handler(status == AVAuthorizationStatusAuthorized);
    }
}

- (void)requestAuthorizationFinished:(NSNumber *)granted
{
    if (granted)
    {
        [self startCamera];
    }
    else
    {
        // handler error
    }
}

#pragma mark - device
- (AVCaptureDevice *)defaultCamera
{
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)frontCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (AVCaptureDeviceInput *)deviceInputWithDevice:(AVCaptureDevice *)device
{
    [self setFlashModeForDevice:device];
    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (!deviceInput) {
        NSLog(@"error = %@", error);
    }
    return deviceInput;
}

- (AVCaptureDeviceInput *)nextDeviceInput
{
    AVCaptureDevicePosition nextPostion = AVCaptureDevicePositionUnspecified;
    if (_deviceInput.device.position == AVCaptureDevicePositionBack)
    {
        nextPostion = AVCaptureDevicePositionFront;
    } else if (_deviceInput.device.position == AVCaptureDevicePositionFront)
    {
        nextPostion = AVCaptureDevicePositionBack;
    }
    if (nextPostion != AVCaptureDevicePositionUnspecified) {
        return [self deviceInputWithDevice:[self cameraWithPosition:nextPostion]];
    }
    return nil;
}
#pragma mark - flashMode
- (void)setFlashMode:(AVCaptureFlashMode)flashMode
{
    if (_flashMode == flashMode) {
        return;
    }
    _flashMode = flashMode;
    [self setFlashModeForDevice:_deviceInput.device];
}

- (void)setFlashModeForDevice:(AVCaptureDevice *)device
{
    if(device.flashMode != _flashMode && [device isFlashModeSupported:_flashMode])
    {
        NSError *error = nil;
        [device lockForConfiguration:&error];
        if (!error) {
            device.flashMode = _flashMode;
        }
        else
        {
            _flashMode = device.flashMode;
        }
        [device unlockForConfiguration];
        
    }
    else
    {
         _flashMode = device.flashMode;
    }
}

#pragma mark - Actions
- (void)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)takeAction:(id)sender
{
    [self takePhoto:^(UIImage *image) {
        [self performSelectorOnMainThread:@selector(takePhotoFinished:) withObject:image waitUntilDone:NO];
    }];
}

- (void)takePhotoFinished:(UIImage *)img
{
//    UIImageWriteToSavedPhotosAlbum(img, self, <#SEL  _Nullable completionSelector#>, <#void * _Nullable contextInfo#>)
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraViewController:imageCaptured:)]) {
        [self.delegate cameraViewController:self imageCaptured:img];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)switchAction:(id)sender
{
    [self switchCamera];
}

- (void)flashAction:(id)sender
{
    TestViewController *alert = [TestViewController alertControllerWithTitle:@"Flash Mode" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    void(^alertAction)(UIAlertAction *action) = ^(UIAlertAction *action) {
        if ([action.title isEqualToString:@"Off"]) {
            self.flashMode = AVCaptureFlashModeOff;
        }
        if ([action.title isEqualToString:@"On"]) {
            self.flashMode = AVCaptureFlashModeOn;
        }
        if ([action.title isEqualToString:@"Auto"]) {
            self.flashMode = AVCaptureFlashModeAuto;
        }
    };
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Off" style:UIAlertActionStyleDefault handler:alertAction];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"On" style:UIAlertActionStyleDefault handler:alertAction];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Auto" style:UIAlertActionStyleDefault handler:alertAction];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    
    __weak typeof(alert ) weakAlert = alert;
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAlert.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - camera
- (BOOL)createCamera
{
    if (_session) {
        return YES;
    }
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    if (![session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        return NO;
    }
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    _deviceInput = [self deviceInputWithDevice:[self defaultCamera]];
    if (!_deviceInput) {
        return NO;
    }
    if (![session canAddInput:_deviceInput]) {
        return NO;
    }
    [session addInput:_deviceInput];
    

    _imageOutPut = [[AVCaptureStillImageOutput alloc] init];
    _imageOutPut.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
    
    if (![session canAddOutput:_imageOutPut]) {
        return NO;
    }
    [session addOutput:_imageOutPut];
    _session = session;
    return YES;
}

- (BOOL)startCamera
{
    if (![self createCamera]) {
        return NO;
    }
    if (_session && ![_session isRunning]) {
        [_session startRunning];
    }
    [self createLayer];
    return YES;
}

- (void)stopCamera
{
    if ([_session isRunning]) {
        [_session stopRunning];
    }
}

- (BOOL)switchCamera
{
    AVCaptureDeviceInput *nextDeviceInput = [self nextDeviceInput];
    if (nextDeviceInput) {
        BOOL success = NO;
        [_session beginConfiguration];
        [_session removeInput:_deviceInput];
        if ([_session canAddInput:nextDeviceInput]) {
            [_session addInput:nextDeviceInput];
            _deviceInput = nextDeviceInput;
            success = YES;
        }
        else
        {
            [_session addInput:_deviceInput];
        }
        
        [_session commitConfiguration];
        return success;
    }
    
    return YES;
}

- (void)takePhoto:(void(^)(UIImage *image))finished
{
    if (!finished) {
        return;
    }
    AVCaptureConnection *connection = [_imageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!connection) {
        finished(nil);
        return;
    }
    [_imageOutPut captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        if (imageDataSampleBuffer == NULL) {
            finished(nil);
            return;
        }
        NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *img = [UIImage imageWithData:data];
        finished(img);
    }];
}

#pragma mark - preview
- (void)createLayer
{
    if (_previewLayer) {
        return;
    }
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _previewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:_previewLayer];
}
@end
