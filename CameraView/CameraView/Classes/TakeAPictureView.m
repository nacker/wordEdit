//
//  TakeAPictureView.m
//  自定义相机
//
//  Created by macbook on 16/9/2.
//  Copyright © 2016年 QIYIKE. All rights reserved.
//

#import "TakeAPictureView.h"
#import <AVFoundation/AVFoundation.h>
// 为了导入系统相册
#import <AssetsLibrary/AssetsLibrary.h>

#import <Photos/Photos.h>
#import "UIImage+info.h"

@interface TakeAPictureView ()
{
    CGRect _imageRect;
}
@property (nonatomic, strong) AVCaptureSession *session;/**< 输入和输出设备之间的数据传递 */
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;/**< 输入设备 */
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;/**< 照片输出流 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;/**< 预览图片层 */
@property (nonatomic, strong) UIImage *image;

@property(nonatomic,weak)UIView* coverViewTop;

@property(nonatomic,weak)UIView* coverViewBottom;

@property(nonatomic,weak)UIView* coverViewLeft;

@property(nonatomic,weak)UIView* coverViewRight;
//拍摄拿到的原图
@property(nonatomic,weak)UIImageView* takedImageView;

@property(nonatomic,weak)UIImageView *imageV;

@end

@implementation TakeAPictureView

- (void)awakeFromNib
{
    [self initAVCaptureSession];
    [self initCameraOverlayView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initCoverView];
        [self initAVCaptureSession];
        UIImageView* takedImageView = [[UIImageView alloc] init];
        self.takedImageView = takedImageView;
        takedImageView.frame = self.bounds;
        takedImageView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:takedImageView];
        
        [self initCameraOverlayView];
        
        [self bringSubviewToFront:_coverViewTop];
        [self bringSubviewToFront:_coverViewLeft];
        [self bringSubviewToFront:_coverViewRight];
        [self bringSubviewToFront:_coverViewBottom];
    }
    return self;
}

- (void)startRunning
{
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)stopRunning
{
    if (self.session) {
        [self.session stopRunning];
    }
}

- (void)initCameraOverlayView{
    CGFloat iPhone6Width  = 375;
    CGFloat widthRadioIPhone6 =(([UIScreen mainScreen].bounds.size.width)/(iPhone6Width));
    CGFloat paddingLeft = 10;
    CGFloat width = self.frame.size.width;
    CGFloat imageVWidth = width - 2 * paddingLeft;
    CGFloat imageVHeight = imageVWidth*430.0/700;
    CGFloat paddingTop = 162 * widthRadioIPhone6;
//    700*430
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(paddingLeft, paddingTop, imageVWidth , imageVHeight)];
    imageV.image = [UIImage imageNamed:@"takephoto_cover"];
    [self addSubview:imageV];
    _imageRect = imageV.frame;
    self.imageV = imageV;
    //设置coverView的frame
    self.coverViewTop.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetMinY(imageV.frame));
    self.coverViewLeft.frame = CGRectMake(0, imageV.frame.origin.y, paddingLeft, imageV.frame.size.height);
    self.coverViewRight.frame = CGRectMake(CGRectGetMaxX(imageV.frame), imageV.frame.origin.y, paddingLeft, imageV.frame.size.height);
    
    self.coverViewBottom.frame = CGRectMake(0, CGRectGetMaxY(imageV.frame),self.frame.size.width , self.frame.size.height - CGRectGetMaxY(imageV.frame));
    
}

-(void)initCoverView{
    UIView* coverViewTop = [[UIView alloc] init];
    [self addSubview:coverViewTop];
    self.coverViewTop = coverViewTop;
    
    UIView* coverViewBottom = [[UIView alloc] init];
    [self addSubview:coverViewBottom];
    self.coverViewBottom = coverViewBottom;
    
    UIView* coverViewLeft= [[UIView alloc] init];
    [self addSubview:coverViewLeft];
    self.coverViewLeft = coverViewLeft;
    
    UIView* coverViewRight = [[UIView alloc] init];
    [self addSubview:coverViewRight];
    self.coverViewRight = coverViewRight;
    
    //设置颜色
    coverViewTop.backgroundColor = [UIColor blackColor];
    coverViewTop.alpha = 0.3;
    coverViewLeft.backgroundColor = [UIColor blackColor];
    coverViewLeft.alpha = 0.3;
    coverViewRight.backgroundColor = [UIColor blackColor];
    coverViewRight.alpha = 0.3;
    coverViewBottom.backgroundColor = [UIColor blackColor];
    coverViewBottom.alpha = 0.3;
    
}

-(void)setCoverViewAlphaBeforeTakPic:(CGFloat)coverViewAlphaBeforeTakPic{
    _coverViewAlphaBeforeTakPic = coverViewAlphaBeforeTakPic;
    _coverViewTop.alpha = coverViewAlphaBeforeTakPic;
    _coverViewLeft.alpha = coverViewAlphaBeforeTakPic;
    _coverViewRight.alpha = coverViewAlphaBeforeTakPic;
    _coverViewBottom.alpha = coverViewAlphaBeforeTakPic;
}

- (void)initAVCaptureSession {
    self.session = [[AVCaptureSession alloc] init];
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    
    // 设置闪光灯自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    // 照片输出流
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    // 设置输出图片格式
    NSDictionary *outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    // 初始化预览层
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self.layer addSublayer:self.previewLayer];
    
}

// 获取设备方向

- (AVCaptureVideoOrientation)getOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        return AVCaptureVideoOrientationLandscapeRight;
    } else if ( deviceOrientation == UIDeviceOrientationLandscapeRight){
        return AVCaptureVideoOrientationLandscapeLeft;
    }
    return (AVCaptureVideoOrientation)deviceOrientation;
}

-(void)updateCoverViewWithAlpha:(CGFloat)alpha{
    _coverViewTop.alpha = alpha;
    _coverViewLeft.alpha = alpha;
    _coverViewRight.alpha = alpha;
    _coverViewBottom.alpha = alpha;
}

// 拍照
- (void)takeAPicture
{
    [self updateCoverViewWithAlpha:self.coverViewAlphaAfterTakPic];
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avOrientation = [self getOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avOrientation];
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage *image = [UIImage imageWithData:jpegData];
        self.takedImageView.image = image;
        image = [UIImage image:image scaleToSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
        image = [UIImage imageFromImage:image inRect:_imageRect];
        
        self.getImage(image);
        
        // 写入相册
        if (self.shouldWriteToSavedPhotos) {
            [self writeToSavedPhotos];
        }
        
    }];
    
}

-(void)resetTakePic{
    [self updateCoverViewWithAlpha:self.coverViewAlphaBeforeTakPic];
    self.takedImageView.image = nil;
    
}

- (void)writeToSavedPhotos
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        NSLog(@"无权限访问相册");
        return;
    }
    
    // 首先判断权限
    if ([self haveAlbumAuthority]) {
        //写入相册
        UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image: didFinishSavingWithError:contextInfo:), nil);
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"写入相册失败%@", error);
    } else {
        self.image = image;
        // 需要修改相册
        NSLog(@"写入相册成功");
    }
}

- (BOOL)haveAlbumAuthority
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
    
}

- (void)setFrontOrBackFacingCamera:(BOOL)isUsingFrontFacingCamera {
    AVCaptureDevicePosition desiredPosition;
    if (isUsingFrontFacingCamera){
        desiredPosition = AVCaptureDevicePositionBack;
    } else {
        desiredPosition = AVCaptureDevicePositionFront;
    }
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
    
}


@end
