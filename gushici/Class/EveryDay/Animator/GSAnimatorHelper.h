//
//  GSAnimatorHelper.h
//  gushici
//
//  Created by ljb48229 on 2018/2/5.
//  Copyright © 2018年 lijiangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSAnimatorHelper : NSObject

+ (CATransform3D)yRotation:(CGFloat)angle;
+ (void)perspectiveTransform:(UIView *)containerView;
@end
