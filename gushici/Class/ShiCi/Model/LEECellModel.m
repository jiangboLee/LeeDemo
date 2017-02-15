//
//  LEECellModel.m
//  3级tableview展示
//
//  Created by 李江波 on 16/10/8.
//  Copyright © 2016年 lijiangbo. All rights reserved.
//

#import "LEECellModel.h"

@implementation LEECellModel

+(instancetype)initWithFatherID:(NSInteger)fatherID nodeID:(NSInteger)nodeID name:(NSString *)name depth:(NSInteger)depth expand:(BOOL)expand{

    return [[self alloc]initWithFatherID:fatherID nodeID:nodeID name:name depth:depth expand:expand];

}

-(instancetype)initWithFatherID:(NSInteger)fatherID nodeID:(NSInteger)nodeID name:(NSString *)name depth:(NSInteger)depth expand:(BOOL)expand{

    if (self = [super init]) {
        
        self.fatherID = fatherID;
        self.nodeID = nodeID;
        self.name = name;
        self.depth = depth;
        self.expand = expand;
        
    }

    return self;

}


@end
