//
//  UIView+UIView_UIViewController.h
//  sinaWeibo
//
//  Created by 李江波 on 2016/11/26.
//  Copyright © 2016年 lijiangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIView_UIViewController)

//视图层次嵌套比较深的时候 使用代理或者闭包的时候会比较麻烦 可以使用这种方式来解决
//遍历响应者链条 查找对应的控制器(导航, tabbarVC,tableVC)

//查找导航视图控制器
-(UINavigationController *)findNavController;

@end
