//
//  GSBaseTableViewCell.h
//  gushici
//
//  Created by 李江波 on 2017/2/14.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSGushiContentModel;

@interface GSBaseTableViewCell : UITableViewCell

@property(nonatomic ,strong) GSGushiContentModel *model;

@end
