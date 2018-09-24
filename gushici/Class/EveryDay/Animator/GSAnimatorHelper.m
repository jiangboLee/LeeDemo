//
//  GSAnimatorHelper.m
//  gushici
//
//  Created by ljb48229 on 2018/2/5.
//  Copyright © 2018年 lijiangbo. All rights reserved.
//

#import "GSAnimatorHelper.h"

@implementation GSAnimatorHelper

+ (CATransform3D)yRotation:(CGFloat)angle {
    return CATransform3DMakeRotation(angle, 0, 1, 0);
}

+ (void)perspectiveTransform:(UIView *)containerView {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    containerView.layer.sublayerTransform = transform;
}

@end
