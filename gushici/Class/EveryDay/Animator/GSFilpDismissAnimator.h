//
//  GSFilpDismissAnimator.h
//  gushici
//
//  Created by 李江波 on 2018/2/5.
//  Copyright © 2018年 lijiangbo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GSInteractionController;

@interface GSFilpDismissAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property(nonatomic, strong) GSInteractionController *interactionController;

- (instancetype)initWithDestinationFrame:(CGRect)rect interactionController:(GSInteractionController *)interactionController;
@end
