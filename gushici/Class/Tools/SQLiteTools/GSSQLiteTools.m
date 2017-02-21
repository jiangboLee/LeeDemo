//
//  WBSQLiteTools.m
//  sinaWeibo
//
//  Created by 李江波 on 2016/11/27.
//  Copyright © 2016年 lijiangbo. All rights reserved.
//

#import "GSSQLiteTools.h"


@interface GSSQLiteTools ()



@end

static id _instance;
@implementation GSSQLiteTools

+(instancetype)shared{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //创建数据库文件 并且打开数据库连接
        //单例对象一旦创建的时候就打开数据
        //必须有值
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        
        NSString *filePath = [path stringByAppendingPathComponent:@"gushi.db"];
        
        _queue = [[FMDatabaseQueue alloc]initWithPath:filePath];
        
        [self createTable];
        
    }
    return self;
}

#pragma mark : - 创建表格
-(void)createTable{

    NSString *sql = @"CREATE TABLE IF NOT EXISTS t_gushi (gushiID INTEGER PRIMARY KEY NOT NULL, name BLOB , time INTEGER);" ;
    NSString *sql2 = @"CREATE TABLE IF NOT EXISTS t_likegushi (gushiID INTEGER PRIMARY KEY NOT NULL, name BLOB, time INTEGER);";
    //使用queue中数据库操作的核心对象来执行sql语句
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
       
        BOOL result = [db executeUpdate:sql];
        
        if (result) {
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
            *rollback = YES;
        }
        
    }];
    //使用queue中数据库操作的核心对象来执行sql语句
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL result = [db executeUpdate:sql2];
        
        if (result) {
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
            *rollback = YES;
        }
        
    }];
    
    
}

@end
