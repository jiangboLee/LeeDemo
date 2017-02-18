//
//  GSTheme.h
//  gushici
//
//  Created by 李江波 on 2017/2/13.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _Font(size) ([[GSTheme gsTheme] lableWithFont:size])
#define _FontName ([[GSTheme gsTheme] lableWithString])
@interface GSTheme : NSObject

+(instancetype)gsTheme;

-(CGFloat)lableWithFont:(CGFloat)font;
-(NSString *)lableWithString;
@end
