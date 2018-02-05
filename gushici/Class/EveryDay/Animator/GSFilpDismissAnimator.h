//
//  GSFilpDismissAnimator.h
//  gushici
//
//  Created by 李江波 on 2018/2/5.
//  Copyright © 2018年 lijiangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSFilpDismissAnimator : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithDestinationFrame:(CGRect)rect;
@end
