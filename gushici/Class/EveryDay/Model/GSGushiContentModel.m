//
//  GSGushiContentModel.m
//  gushici
//
//  Created by 李江波 on 2017/2/12.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSGushiContentModel.h"

@implementation GSGushiContentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"gushiID"  : @"id"};
}

-(void)encodeWithCoder:(NSCoder *)aCoder{

    [self yy_modelEncodeWithCoder:aCoder];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}
@end
