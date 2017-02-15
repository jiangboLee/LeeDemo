//
//  LEECellModel.h
//  3级tableview展示
//
//  Created by 李江波 on 16/10/8.
//  Copyright © 2016年 lijiangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEECellModel : NSObject


/**
 父节点ID
 */
@property(nonatomic ,assign) NSInteger fatherID;

/**
 本节点ID
 */
@property(nonatomic ,assign) NSInteger nodeID;

@property(nonatomic ,copy) NSString *name;

/**
 节点深度
 */
@property(nonatomic ,assign)  NSInteger depth;


/**
 是否展开
 */
@property(nonatomic ,assign) BOOL expand;


-(instancetype)initWithFatherID:(NSInteger)fatherID nodeID:(NSInteger)nodeID name:(NSString *)name depth:(NSInteger)depth expand:(BOOL)expand;

+(instancetype)initWithFatherID:(NSInteger)fatherID nodeID:(NSInteger)nodeID name:(NSString *)name depth:(NSInteger)depth expand:(BOOL)expand;


@end
