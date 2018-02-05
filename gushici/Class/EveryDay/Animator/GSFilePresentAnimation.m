//
//  GSFilePresentAnimation.m
//  gushici
//
//  Created by ljb48229 on 2018/2/5.
//  Copyright © 2018年 lijiangbo. All rights reserved.
//

#import "GSFilePresentAnimation.h"
#import "GSAnimatorHelper.h"

@interface GSFilePresentAnimation()

@property(nonatomic, assign) CGRect originFrame;
@end

@implementation GSFilePresentAnimation

- (instancetype)initWithOriginFrame:(CGRect)rect {
    self = [super init];
    if (self) {
        self.originFrame = rect;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.5;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIPageViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    
    [GSAnimatorHelper perspectiveTransform:containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIImageView *snapshot = [[UIImageView alloc]initWithImage:[UIImage viewToImage:toVC.view]];
    snapshot.contentMode = UIViewContentModeScaleAspectFit;
//    UIView *snapshot = [toVC.view snapshotViewAfterScreenUpdates:YES];
    snapshot.frame = CGRectMake(self.originFrame.origin.x, self.originFrame.origin.y + 49, self.originFrame.size.width, self.originFrame.size.height);
    snapshot.layer.cornerRadius = 10;
    snapshot.layer.masksToBounds = YES;
    snapshot.layer.transform = [GSAnimatorHelper yRotation:M_PI_2];
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapshot];
    [toVC.view setHidden:YES];
//    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
////        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1 animations:^{
////            fromVC.view.layer.transform = [GSAnimatorHelper yRotation:- M_PI_2];
////        }];
//        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/2 animations:^{
//            snapshot.layer.transform = [GSAnimatorHelper yRotation:0];
//        }];
//        [UIView addKeyframeWithRelativeStartTime:1/2 relativeDuration:1/2 animations:^{
//            snapshot.frame = finalFrame;
//            snapshot.layer.cornerRadius = 0;
//        }];
//    } completion:^(BOOL finished) {
//        [toVC.view setHidden:NO];
//        [snapshot removeFromSuperview];
//        fromVC.view.layer.transform = CATransform3DIdentity;
//        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
//    }];
    [UIView animateWithDuration:duration/3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        fromVC.view.layer.transform = [GSAnimatorHelper yRotation:- M_PI_2];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration/3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            snapshot.layer.transform = [GSAnimatorHelper yRotation:0];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration/3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                snapshot.frame = finalFrame;
                snapshot.layer.cornerRadius = 0;
            } completion:^(BOOL finished) {
                [toVC.view setHidden:NO];
                [snapshot removeFromSuperview];
                fromVC.view.layer.transform = CATransform3DIdentity;
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }];
    }];
}

@end






