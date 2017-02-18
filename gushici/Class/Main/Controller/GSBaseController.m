//
//  GSBaseController.m
//  gushici
//
//  Created by 李江波 on 2017/2/13.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSBaseController.h"

@interface GSBaseController ()

@end

@implementation GSBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLableFont) name:@"zitigushi" object:nil];
}

-(void)changeLableFont{

    [self findSubview:self.view];
   
}
//遍历子控件
-(void)findSubview:(UIView *)vvv{
    for (UIView *v in vvv.subviews) {
        
//        NSLog(@"%@",[v class]);
        if ([v isKindOfClass:[UILabel class]]) {
            double change = [[NSUserDefaults standardUserDefaults] doubleForKey:@"ziti"];
            UILabel *vv = (UILabel *)v;
            
            vv.font = [UIFont fontWithName:[[NSUserDefaults standardUserDefaults] objectForKey:@"zitiType"] size:vv.font.pointSize + change];
        }
        
        if (v.subviews.count > 0) {
            [self findSubview:v];
        }
        
    }
    
}

@end
