//
//  YCAlertController.m
//  YCAlertController
//
//  Created by nacker on 2017/7/26.
//  Copyright © 2017年 nacker. All rights reserved.
//

#import "YCAlertController.h"
#import "YCCenterAnimationController.h"
#import "Masonry.h"

@interface YCAlertController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *cancelText;
@property (nonatomic, copy) NSString *buttonText;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) UIButton *defaultBtn;

@property (nonatomic, copy) void (^buttonAction)();

@end

@implementation YCAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title cancel:(NSString *)cancel button:(NSString *)button action:(void (^)())buttonAction
{
    YCAlertController *alert = [[YCAlertController alloc] init];
    alert.transitioningDelegate = alert;
    alert.modalPresentationStyle = UIModalPresentationCustom;
    alert.titleText = title;
    alert.cancelText = cancel ? cancel : @"取消";
    alert.buttonText = button;
    alert.buttonAction = buttonAction;
    return alert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.backgroundView.alpha = 0.3;
    self.backgroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.backgroundView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@115);
        make.center.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(42.5);
        make.right.equalTo(self.view.mas_right).offset(-42.5);
    }];
    
    self.contentView.backgroundColor = [UIColor redColor];
    
    
    
//    self.titleLabel.text = self.titleText;
//    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//    self.titleLabel.textColor = [UIColor blackColor];
//    
//    // 取消
//    [self.cancelBtn setTitle:self.cancelText forState:UIControlStateNormal];
//    [self.cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    
//    // 确认
//    [self.defaultBtn setTitle:self.buttonText forState:UIControlStateNormal];
//    [self.defaultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.defaultBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//    
//    // 事件
//    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchDown];
//    [self.defaultBtn addTarget:self action:@selector(defaultBtnClick) forControlEvents:UIControlEventTouchDown];

}

- (void)cancelBtnClick
{
    self.buttonAction();
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)defaultBtnClick
{
    self.buttonAction();
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- UIViewControllerTransitioningDelegate --

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[YCCenterAnimationController alloc] init];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[YCCenterAnimationController alloc] init];
}
@end
