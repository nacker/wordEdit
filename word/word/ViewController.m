//
//  ViewController.m
//  word
//
//  Created by nacker on 2017/6/7.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextViewDelegate>

@property (nonatomic, weak) UITextView *textView;

@property (nonatomic, assign) NSInteger style;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑器";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStyleDone target:self action:@selector(previewAction)];
    
    [self createTextView];
    [self addKeyboardNotification];
}

#pragma mark - 创建textView
- (void)createTextView {
    
    //markdown输入框
    UITextView *textView = [[UITextView alloc] init];
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont fontWithName:YouYouNormalFont size:17];
    textView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:textView];
    self.textView = textView;
    
    textView.backgroundColor = [UIColor redColor];
    textView.alwaysBounceVertical = YES;
    
    __weak typeof(self) weakSelf = self;
    textView.inputAccessoryView = [BYMarkdownKeyboard toolbarViewWithTextView:_textView keybordBlock:^(NSInteger index) {
        
        switch (index) {
            case 1:
                [textView resignFirstResponder];
                break;
            case 2:
                [weakSelf helpAction];
                break;
            case 3:
                textView.text = nil;
                break;
            case 4:
                [textView resignFirstResponder];
//                [weakSelf changeStyle];
                break;
            case 5:
                [weakSelf previewAction];
                break;
        }
    }];
    
    [self.textView becomeFirstResponder];
}


#pragma mark - 代理
- (void)btnClickWithIndex:(NSInteger)index {
    
    if (index == 1) {
        self.style = 1;
    } else if (index == 2) {
        self.style = 2;
    } else if (index == 3) {
        self.style = 3;
    } else {
        self.style = 4;
    }
    
    [self.textView becomeFirstResponder];
}


#pragma mark - 预览
- (void)previewAction {
    
    PreviewViewController *preview = [[PreviewViewController alloc] init];
    preview.style = self.style;
    // 把markdown语法转成html
    preview.content = [MMMarkdown HTMLStringWithMarkdown:self.textView.text extensions:MMMarkdownExtensionsGitHubFlavored error:NULL];
    
    [self.navigationController pushViewController:preview animated:YES];
}

#pragma mark - markdown语法
- (void)helpAction {
    
    HelpViewController *helpView = [[HelpViewController alloc] init];
    [self.navigationController pushViewController:helpView animated:YES];
}


- (void)btnClick
{
    UIViewController *vc = [[UIViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 键盘的处理
- (void)addKeyboardNotification {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 键盘弹起
- (void)keyBoardWillShow:(NSNotification *)noti
{
    CGFloat keyboardH = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    // 获取键盘出现的时间
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.textView.contentInset = UIEdgeInsetsMake(64, 0, keyboardH, 0);
    }];
}

#pragma mark - 键盘收回
- (void)keyBoardWillHidden:(NSNotification *)noti{
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
