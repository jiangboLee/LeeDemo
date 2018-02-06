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
    return 1.1;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIPageViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    
    [GSAnimatorHelper perspectiveTransform:containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    //，10.3.3有问题，要传个尺寸；
    UIImageView *snapshot = [[UIImageView alloc]initWithImage:[UIImage viewToImage:toVC.view size:finalFrame.size]];
    snapshot.contentMode = UIViewContentModeScaleAspectFit;
//    UIView *snapshot = [toVC.view snapshotViewAfterScreenUpdates:YES];
    snapshot.frame = CGRectMake(self.originFrame.origin.x, self.originFrame.origin.y + 49, self.originFrame.size.width, self.originFrame.size.height);
    snapshot.layer.cornerRadius = 10;
    snapshot.layer.masksToBounds = YES;
    snapshot.layer.transform = [GSAnimatorHelper yRotation:M_PI_2];
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapshot];
    [toVC.view setHidden:YES];
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1/3.0 animations:^{
            fromVC.view.layer.transform = [GSAnimatorHelper yRotation:- M_PI_2];
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations:^{
            snapshot.layer.transform = [GSAnimatorHelper yRotation:0];
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations:^{
            
            snapshot.frame = finalFrame;
            snapshot.layer.cornerRadius = 0;
        }];
    } completion:^(BOOL finished) {
        [toVC.view setHidden:NO];
        [snapshot removeFromSuperview];
        fromVC.view.layer.transform = CATransform3DIdentity;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end






