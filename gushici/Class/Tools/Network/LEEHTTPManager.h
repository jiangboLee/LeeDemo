//
//  LEEHTTPManager.h
//  oc网络请求封装
//
//  Created by 李江波 on 2016/11/13.
//  Copyright © 2016年 lijiangbo. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, NetworkStates) {
    NetworkStatesNone, //没有网络
    NetworkStates2G,
    NetworkStates3G,
    NetworkStates4G,
    NetworkStatesWIFI
};

typedef NS_OPTIONS(NSUInteger, kMethod) {
    GET = 1,
    POST = 2,
};

@interface LEEHTTPManager : AFHTTPSessionManager

+ (instancetype) share;

/**
 网络状态

 @return 网络状态
 */
+(NetworkStates)getNetworkState;


/*
 1.方法
 2.urlstring
 3.参数
 4.回调   成功，失败
 
 */

-(void) request:(kMethod)method UrlString:(NSString *)UrlString parameters:(id)parameters finshed:(void(^)(id responseObject, NSError*error))finshed;


@end
