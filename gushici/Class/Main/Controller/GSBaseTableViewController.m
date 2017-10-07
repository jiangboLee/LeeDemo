//
//  GSBaseTableViewController.m
//  gushici
//
//  Created by 李江波 on 2017/10/7.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSBaseTableViewController.h"

@interface GSBaseTableViewController ()

@end

@implementation GSBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
#endif
    
    
}


@end
