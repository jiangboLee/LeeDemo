//
//  UIImage+Antialias.h
//  BuDeJie
//
//  Created by ljb on 15/10/31.
//  Copyright © 2015年 ljb. All rights reserved.
//  抗锯齿

#import <UIKit/UIKit.h>

@interface UIImage (Antialias)

// 返回一张抗锯齿图片
// 本质：在图片生成一个透明为1的像素边框
- (UIImage *)imageAntialias;

/**
 *  根据颜色生成一张图片
 *
 *  @param color 颜色
 *  @param size  图片大小
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  生成圆角的图片
 *
 *  @param originImage 原始图片
 *  @param borderColor 边框原色
 *  @param borderWidth 边框宽度
 *
 *  @return 圆形图片
 */
+ (UIImage *)circleImage:(UIImage *)originImage borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**
 *  生成一张高斯模糊的图片
 *
 *  @param image 原图
 *  @param blur  模糊程度 (0~1)
 *
 *  @return 高斯模糊图片
 */
+ (UIImage *)blurImage:(UIImage *)image blur:(CGFloat)blur;

@end
