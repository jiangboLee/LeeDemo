//
//  GSFilePresentAnimation.h
//  gushici
//
//  Created by ljb48229 on 2018/2/5.
//  Copyright © 2018年 lijiangbo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GSFilePresentAnimation : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithOriginFrame:(CGRect)rect;
@end
