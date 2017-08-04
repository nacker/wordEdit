//
//  ViewController.m
//  YCAlertController
//
//  Created by nacker on 2017/7/26.
//  Copyright © 2017年 nacker. All rights reserved.
//

#import "ViewController.h"
#import "YCAlertController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchDown];
}

- (void)btnClick
{
    YCAlertController *alert = [YCAlertController alertControllerWithTitle:@"你好!" cancel:@"取消" button:@"确认" action:^{
        
    }];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
@end
