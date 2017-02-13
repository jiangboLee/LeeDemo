//
//  UIView+Frame.m
//  BuDeJie
//
//  Created by xiaomage on 16/3/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
- (void)setLjb_height:(CGFloat)ljb_height
{
    CGRect rect = self.frame;
    rect.size.height = ljb_height;
    self.frame = rect;
}

- (CGFloat)ljb_height
{
    return self.frame.size.height;
}

- (CGFloat)ljb_width
{
    return self.frame.size.width;
}
- (void)setLjb_width:(CGFloat)ljb_width
{
    CGRect rect = self.frame;
    rect.size.width = ljb_width;
    self.frame = rect;
}

- (CGFloat)ljb_x
{
    return self.frame.origin.x;
    
}

- (void)setLjb_x:(CGFloat)ljb_x
{
    CGRect rect = self.frame;
    rect.origin.x = ljb_x;
    self.frame = rect;
}

- (void)setLjb_y:(CGFloat)ljb_y
{
    CGRect rect = self.frame;
    rect.origin.y = ljb_y;
    self.frame = rect;
}

- (CGFloat)ljb_y
{
    
    return self.frame.origin.y;
}

- (void)setLjb_centerX:(CGFloat)ljb_centerX
{
    CGPoint center = self.center;
    center.x = ljb_centerX;
    self.center = center;
}

- (CGFloat)ljb_centerX
{
    return self.center.x;
}

- (void)setLjb_centerY:(CGFloat)ljb_centerY
{
    CGPoint center = self.center;
    center.y = ljb_centerY;
    self.center = center;
}

- (CGFloat)ljb_centerY
{
    return self.center.y;
}

-(void)setLjb_size:(CGSize)ljb_size{
    
    CGRect rect = self.bounds;
    rect.size = ljb_size;
    self.bounds = rect;
}

-(CGSize)ljb_size{

    return self.bounds.size;
}
@end
