//
//  UITextView+Addition.m
//  gushici
//
//  Created by 李江波 on 2017/2/20.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "UITextView+Addition.h"

@implementation UITextView (Addition)

+(void)changeLineSpaceForLabel:(UITextView *)textView WithSpace:(float)space{

    NSString *labelText = textView.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    textView.attributedText = attributedString;
    textView.textAlignment = NSTextAlignmentCenter;
    [textView sizeToFit];
}

@end
