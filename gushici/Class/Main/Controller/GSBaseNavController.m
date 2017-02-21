//
//  GSBaseNavController.m
//  gushici
//
//  Created by 李江波 on 2017/2/13.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSBaseNavController.h"

@interface GSBaseNavController ()

@end

@implementation GSBaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:_FontName size:20]}];
    
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if (self.childViewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *backItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"nav_back"] highImage:[UIImage imageNamed:@"nav_back_highlighted"] target:self action:@selector(pop) title:@"返回"];
        viewController.navigationItem.leftBarButtonItem = backItem;
    }
    [super pushViewController:viewController animated:animated];
}

-(void)pop{
    
    [self popViewControllerAnimated:YES];
}

@end
