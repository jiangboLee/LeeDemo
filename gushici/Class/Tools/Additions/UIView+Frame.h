//
//  UIView+Frame.h
//  BuDeJie
//
//  Created by xiaomage on 16/3/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 
    写分类:避免跟其他开发者产生冲突,加前缀
 
 */
@interface UIView (Frame)

@property CGFloat ljb_width;
@property CGFloat ljb_height;
@property CGFloat ljb_x;
@property CGFloat ljb_y;
@property CGFloat ljb_centerX;
@property CGFloat ljb_centerY;
@property CGSize ljb_size;

@end
