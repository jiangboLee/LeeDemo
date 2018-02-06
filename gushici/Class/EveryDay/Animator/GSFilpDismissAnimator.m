//
//  GSFilpDismissAnimator.m
//  gushici
//
//  Created by 李江波 on 2018/2/5.
//  Copyright © 2018年 lijiangbo. All rights reserved.
//

#import "GSFilpDismissAnimator.h"
#import "GSAnimatorHelper.h"

@interface GSFilpDismissAnimator()

@property(nonatomic, assign) CGRect destinationFrame;

@end

@implementation GSFilpDismissAnimator

- (instancetype)initWithDestinationFrame:(CGRect)rect interactionController:(GSInteractionController *)interactionController{
    self = [super init];
    if (self) {
        self.destinationFrame = rect;
        self.interactionController = interactionController;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.7;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIImageView *snapshot = [[UIImageView alloc] initWithImage:[UIImage viewToImage:fromVC.view]];
    snapshot.frame = CGRectMake(fromVC.view.frame.origin.x, fromVC.view.frame.origin.y, fromVC.view.frame.size.width, fromVC.view.frame.size.height);
    snapshot.contentMode = UIViewContentModeScaleAspectFit;
    snapshot.layer.cornerRadius = 10;
    snapshot.layer.masksToBounds = YES;
    
    UIView *containerView = transitionContext.containerView;
    [containerView insertSubview:toVC.view atIndex:0];
    [containerView addSubview:snapshot];
    [fromVC.view setHidden:YES];
    
    [GSAnimatorHelper perspectiveTransform:containerView];
    toVC.view.layer.transform = [GSAnimatorHelper yRotation:- M_PI_2];
    CGFloat duration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1/3.0 animations:^{
            snapshot.frame = CGRectMake(self.destinationFrame.origin.x, self.destinationFrame.origin.y + 49, self.destinationFrame.size.width, self.destinationFrame.size.height);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations:^{
            snapshot.layer.transform = [GSAnimatorHelper yRotation:M_PI_2];
        }];
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations:^{
            toVC.view.layer.transform = [GSAnimatorHelper yRotation:0];
        }];
    } completion:^(BOOL finished) {
        [fromVC.view setHidden:NO];
        [snapshot removeFromSuperview];
        if (transitionContext.transitionWasCancelled) {
            [toVC.view removeFromSuperview];
        }
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}


@end






