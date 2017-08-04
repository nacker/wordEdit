//
//  YCCenterAnimationController.m
//  YCAlertController
//
//  Created by nacker on 2017/7/26.
//  Copyright © 2017年 nacker. All rights reserved.
//

#import "YCCenterAnimationController.h"
#import "YCAlertController.h"

@implementation YCCenterAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 1
    UIViewController *toVC = (YCAlertController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (toVC.isBeingPresented) {
        return 0.3;
    }
    else if (fromVC.isBeingDismissed) {
        return 0.1;
    }
    
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    YCAlertController *toVC = (YCAlertController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (!toVC || !fromVC) {
        return;
    }
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    if (toVC.isBeingPresented) {
        // 2
        [containerView addSubview:toVC.view];
        toVC.view.frame = CGRectMake(0.0, 0.0, containerView.frame.size.width, containerView.frame.size.height);
        toVC.backgroundView.alpha = 0.0;
        CGAffineTransform oldTransform = toVC.contentView.transform;
        toVC.contentView.transform = CGAffineTransformScale(oldTransform, 0.3, 0.3);
        toVC.contentView.center = containerView.center;
        [UIView animateWithDuration:duration animations:^{
            toVC.backgroundView.alpha = 0.3;
            toVC.contentView.transform = oldTransform;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    else if (fromVC.isBeingDismissed) {
        // 3
        [UIView animateWithDuration:duration animations:^{
            fromVC.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}
@end
