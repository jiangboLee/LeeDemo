//
//  UIButton+CZAddition.h
//
//  Created by 刘凡 on 16/5/17.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CZAddition)

/// 创建文本按钮
///
/// @param title         文本
/// @param fontSize      字体大小
/// @param normalColor   默认颜色
/// @param selectedColor 选中颜色
///
/// @return UIButton
+ (instancetype)cz_textButton:(NSString *)title fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor;

+ (instancetype)textButton:(NSString *)title fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor backgroundImage:(NSString *)imageName;

+ (instancetype)Button:(NSString *)title fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor ImageName:(NSString *)imageName;

@end
