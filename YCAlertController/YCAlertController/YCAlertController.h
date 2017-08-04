//
//  YCAlertController.h
//  YCAlertController
//
//  Created by nacker on 2017/7/26.
//  Copyright © 2017年 nacker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KAlertControllerStyle) {
    KAlertControllerStyleActionSheet = 0,
    KAlertControllerStyleAlert,
    KAlertControllerStyleCustomView
};

@interface YCAlertController : UIViewController

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *contentView;

+ (instancetype)alertControllerWithTitle:(NSString *)title cancel:(NSString *)cancel button:(NSString *)button action:(void (^)())buttonAction;

@end
