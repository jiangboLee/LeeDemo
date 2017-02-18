//
//  GSTheme.m
//  gushici
//
//  Created by 李江波 on 2017/2/13.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSTheme.h"

static GSTheme *_gsTheme;
@implementation GSTheme

+(instancetype)gsTheme{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _gsTheme = [[self alloc]init];
        
        
    });
    
    return _gsTheme;
}

-(CGFloat)lableWithFont:(CGFloat)font{
    
    double fo = [[NSUserDefaults standardUserDefaults] doubleForKey:@"ziti"];
    
    return font + 0;
    
}


@end
