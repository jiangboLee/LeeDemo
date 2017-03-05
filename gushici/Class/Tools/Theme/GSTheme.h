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
#define _Str(key) ([[GSTheme gsTheme] localizedStringForKey:key])
@interface GSTheme : NSObject

+(instancetype)gsTheme;

-(CGFloat)lableWithFont:(CGFloat)font;
-(NSString *)lableWithString;

// 本地化字符串
- (NSString *)localizedStringForKey:(NSString *)key;
@end
