//
//  GSCardViewController.h
//  gushici
//
//  Created by ljb48229 on 2018/2/5.
//  Copyright © 2018年 lijiangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSCardViewController : UIViewController

@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, strong) GSGushiContentModel *model;
@property(nonatomic, strong) NSDictionary *dataDic;
@end
