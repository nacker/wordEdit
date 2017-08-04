//
//  CameraViewController.m
//  CameraView
//
//  Created by Zippo on 2017/7/19.
//  Copyright © 2017年 Zippo. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TakeAPictureView.h"

#define WeakSelf    __weak typeof(self) weakSelf = self;
#define StrongSelf  __strong typeof(weakSelf) self = weakSelf;

@interface CameraViewController ()

@property(nonatomic,weak)TakeAPictureView* cameraView;

@property(nonatomic,weak)UIButton* takePicButton;

@property(nonatomic,weak)UIButton* chooseButton;

@property(nonatomic,weak)UIButton* retakePicButton;

@property(nonatomic,strong)UIImage* clipedImage;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubViews];
    [self.cameraView startRunning];
}
/**
 * 创建子控件
*/
-(void)setUpSubViews{
    //1.创建相机拍摄视图
    TakeAPictureView* cameraView = [[TakeAPictureView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:cameraView];
    cameraView.coverViewAlphaBeforeTakPic = 0.3;
    cameraView.coverViewAlphaAfterTakPic = 0.5;
    self.cameraView = cameraView;
    __weak typeof(self)weakSelf = self;
    cameraView.getImage = ^(UIImage* image){
        weakSelf.clipedImage = image;
    };
    
    UIButton* takePicButton = [[UIButton alloc] init];
    self.takePicButton = takePicButton;
    [self.view addSubview:takePicButton];
    CGFloat buttonWH = 95;
    CGFloat buttonPaddingBottom = 90;
    CGFloat buttonX = (self.view.frame.size.width - buttonWH) * 0.5;
    CGFloat buttonY = (self.view.frame.size.height - buttonWH - buttonPaddingBottom);
    takePicButton.frame = CGRectMake(buttonX, buttonY, buttonWH, buttonWH);
    [takePicButton setImage:[UIImage imageNamed:@"takepic_icon"] forState:UIControlStateNormal];
    [takePicButton addTarget:self action:@selector(takePictureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    CGFloat confirmReTakeButtonH = 25;
    CGFloat confirmReTakeButtonW = 40;
    CGFloat onfirmReTakeButtonPaddingBottom = 35;
    CGFloat onfirmReTakeButtonPaddingLeftRight = 50;
    UIButton* chooseButton = [[UIButton alloc] init];
    self.chooseButton = chooseButton;
    [self.view addSubview:chooseButton];
    [chooseButton setTitle:@"确认" forState:UIControlStateNormal];
    chooseButton.frame = CGRectMake(self.view.frame.size.width - confirmReTakeButtonW - onfirmReTakeButtonPaddingLeftRight,self.view.frame.size.height - onfirmReTakeButtonPaddingBottom - confirmReTakeButtonH, confirmReTakeButtonW, confirmReTakeButtonH);
    [chooseButton addTarget:self action:@selector(chooseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton* retakePicButton = [[UIButton alloc] init];
    [retakePicButton setTitle:@"重拍" forState:UIControlStateNormal];
    self.retakePicButton = retakePicButton;
    [self.view addSubview:retakePicButton];
    retakePicButton.frame = CGRectMake(onfirmReTakeButtonPaddingLeftRight,self.view.frame.size.height - onfirmReTakeButtonPaddingBottom - confirmReTakeButtonH, confirmReTakeButtonW, confirmReTakeButtonH);
    [retakePicButton addTarget:self action:@selector(retakePicButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.retakePicButton.hidden = YES;
    self.chooseButton.hidden = YES;
    self.takePicButton.hidden = NO;
}

-(void)takePictureButtonClick{
    [self.cameraView takeAPicture];
    
    self.retakePicButton.hidden = NO;
    self.chooseButton.hidden = NO;
    self.takePicButton.hidden = YES;
}

-(void)chooseButtonClick{
    if([self.delegate respondsToSelector:@selector(didFinishTakePhotoWithClipedImage:)]){
        [self.delegate didFinishTakePhotoWithClipedImage:self.clipedImage];
    }
    NSLog(@"选取的图片信息%@",self.clipedImage);
}

-(void)retakePicButtonClick{
    self.retakePicButton.hidden = YES;
    self.chooseButton.hidden = YES;
    self.takePicButton.hidden = NO;
    
    [self.cameraView resetTakePic];
}



@end
