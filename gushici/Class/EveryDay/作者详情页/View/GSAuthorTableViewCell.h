//
//  GSAuthorTableViewCell.h
//  gushici
//
//  Created by ljb48229 on 2018/2/2.
//  Copyright © 2018年 lijiangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSGushiContentModel.h"

typedef void(^LookMoreClickBlock)(BOOL more);
@interface GSAuthorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *needMoreButton;
@property(nonatomic, strong) GSGushiContentModel *model;
@property(nonatomic, copy) LookMoreClickBlock lookMoreClickBlock;
@end
