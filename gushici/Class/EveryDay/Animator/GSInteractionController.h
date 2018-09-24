//
//  GSIneractionController.h
//  gushici
//
//  Created by 李江波 on 2018/2/5.
//  Copyright © 2018年 lijiangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSInteractionController : UIPercentDrivenInteractiveTransition

@property(nonatomic, assign) BOOL interactionInProgress;
- (instancetype)initWithViewController:(UIViewController *)VC;
@end
