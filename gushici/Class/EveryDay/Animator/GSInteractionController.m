//
//  GSIneractionController.m
//  gushici
//
//  Created by 李江波 on 2018/2/5.
//  Copyright © 2018年 lijiangbo. All rights reserved.
//

#import "GSInteractionController.h"
@interface GSInteractionController()

@property(nonatomic, weak) UIViewController *VC;
@property(nonatomic, assign) BOOL shouldCompleteTransition;
@end

@implementation GSInteractionController

- (instancetype)initWithViewController:(UIViewController *)VC {
    self = [super init];
    if (self) {
        self.VC = VC;
        [self prepareGestureRecognizer:VC.view];
    }
    return self;
}

- (void)prepareGestureRecognizer:(UIView *)view {
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    edgePan.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:edgePan];
}

- (void)handleGesture:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    CGFloat progess = translation.x / 200;
    progess = fminf(fmaxf(progess, 0.0), 1.0);
    NSLog(@"%f",progess);
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.interactionInProgress = true;
            [self.VC.navigationController popViewControllerAnimated:YES];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.shouldCompleteTransition = progess > 0.5;
            [self updateInteractiveTransition:progess];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            self.interactionInProgress = false;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            self.interactionInProgress = false;
            if (self.shouldCompleteTransition) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            
        }
            break;
            
        default:
            break;
    }
}
@end








