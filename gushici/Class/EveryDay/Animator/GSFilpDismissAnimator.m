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

- (instancetype)initWithDestinationFrame:(CGRect)rect {
    self = [super init];
    if (self) {
        self.destinationFrame = rect;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIImageView *snapshot = [[UIImageView alloc] initWithImage:[UIImage viewToImage:fromVC.view]];
    snapshot.frame = CGRectMake(fromVC.view.frame.origin.x, fromVC.view.frame.origin.y + 49, fromVC.view.frame.size.width, fromVC.view.frame.size.height);
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
    
    [UIView animateWithDuration:duration / 3 animations:^{
        snapshot.frame = CGRectMake(self.destinationFrame.origin.x, self.destinationFrame.origin.y + 49, self.destinationFrame.size.width, self.destinationFrame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration / 3 animations:^{
            snapshot.layer.transform = [GSAnimatorHelper yRotation:M_PI_2];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration / 3 animations:^{
                toVC.view.layer.transform = [GSAnimatorHelper yRotation:0];
            } completion:^(BOOL finished) {
                [fromVC.view setHidden:NO];
                [snapshot removeFromSuperview];
                if (transitionContext.transitionWasCancelled) {
                    [toVC.view removeFromSuperview];
                }
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }];
    }];
}


@end






