//
//  GSDetailController.h
//  gushici
//
//  Created by 李江波 on 2017/2/13.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSBaseController.h"

@interface GSDetailController : GSBaseController

@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, copy) NSString *mingju;
@property(nonatomic, assign) NSInteger gushiID;
@property(nonatomic, assign) BOOL isMingjuSearch;

@property(nonatomic, strong) NSDictionary *responseObject;
@end
