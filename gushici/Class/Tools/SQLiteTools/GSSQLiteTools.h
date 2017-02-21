//
//  WBSQLiteTools.h
//  sinaWeibo
//
//  Created by 李江波 on 2016/11/27.
//  Copyright © 2016年 lijiangbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface GSSQLiteTools : NSObject


+(instancetype) shared;

@property(nonatomic ,strong) FMDatabaseQueue *queue;

@end
