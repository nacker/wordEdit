//
//  DemoIndexViewController.m
//  CameraView
//
//  Created by Zippo on 2017/7/19.
//  Copyright © 2017年 Zippo. All rights reserved.
//

#import "DemoIndexViewController.h"
#import "CameraViewController.h"

@interface DemoIndexViewController ()<CameraViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DemoIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Index";
    
}
- (IBAction)takePicBUttonCLick:(id)sender {
    CameraViewController* cameraVc =[[CameraViewController alloc] init];
    cameraVc.delegate = self;
    [self.navigationController pushViewController:cameraVc animated:YES];
}

-(void)didFinishTakePhotoWithClipedImage:(UIImage *)clipedImage{
    self.imageView.image = clipedImage;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
