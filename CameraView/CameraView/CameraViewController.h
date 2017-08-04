//
//  CameraViewController.h
//  CameraView
//
//  Created by Zippo on 2017/7/19.
//  Copyright © 2017年 Zippo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraViewControllerDelegate <NSObject>

-(void)didFinishTakePhotoWithClipedImage:(UIImage*)clipedImage;

@end

@interface CameraViewController : UIViewController

@property(nonatomic,weak)id<CameraViewControllerDelegate> delegate;

@end
