//
//  GushiContent.h
//  gushici
//
//  Created by 李江波 on 2017/2/12.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSGushiContentModel;

@interface GushiContent : UIView

@property(nonatomic ,strong) GSGushiContentModel *model;
@property (weak, nonatomic) IBOutlet UIButton *clickChangeBotton;

+(instancetype)gushiContent;

@end
