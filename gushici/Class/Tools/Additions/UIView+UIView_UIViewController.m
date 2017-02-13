//
//  UIView+UIView_UIViewController.m
//  sinaWeibo
//
//  Created by 李江波 on 2016/11/26.
//  Copyright © 2016年 lijiangbo. All rights reserved.
//

#import "UIView+UIView_UIViewController.h"


@implementation UIView (UIView_UIViewController)

-(UINavigationController *)findNavController{

    //1. 获取当前控件的下一个响应者
    UIResponder *responder = self.nextResponder;
    
    while (responder != nil) {
        
        if ([responder isKindOfClass:[UINavigationController class]]) {
            
            return (UINavigationController *)responder;
        }
        //如果不是  就查找下一个响应者的下一个响应者
        responder = responder.nextResponder;
        
    }
    
    return nil;
}

@end
