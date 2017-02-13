//
//  LEEHTTPManager.m
//  oc网络请求封装
//
//  Created by 李江波 on 2016/11/13.
//  Copyright © 2016年 lijiangbo. All rights reserved.
//

#import "LEEHTTPManager.h"

@protocol HTTPProxy <NSObject>
//AFN私有方法。用代理伪装，骗过编译器
@optional
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end

@interface LEEHTTPManager ()<HTTPProxy>


@end

@implementation LEEHTTPManager

static LEEHTTPManager *_instace;
+(instancetype)share{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instace = [[self alloc]init];
        
        //@"application/json", @"text/json", @"text/javascript"
        _instace.responseSerializer.acceptableContentTypes = [_instace.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
//        NSLog(@"%@",_instace.responseSerializer.acceptableContentTypes);
        
    });
    
    return _instace;
}


//判断网络类型
+(NetworkStates)getNetworkState{

    NSArray *subviews = [[[[UIApplication sharedApplication]valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    NetworkStates states = NetworkStatesNone;
    for (id child in subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            int networkType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (networkType) {
                case 0:
                    states = NetworkStatesNone;
                    break;
                case 1:
                    states = NetworkStates2G;
                    break;
                case 2:
                    states = NetworkStates3G;
                    break;
                case 3:
                    states = NetworkStates4G;
                    break;
                case 5:
                    states = NetworkStatesWIFI;
                    break;
                    
                default:
                    break;
            }
        }
    }
    return states;
}


-(void)request:(kMethod)method UrlString:(NSString *)UrlString parameters:(id)parameters finshed:(void (^)(id, NSError *))finshed{
    
    void(^successBlock)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject) = ^(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject){
    
        finshed(responseObject , nil);
    };
    
    void(^errorBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        
        finshed(nil , error);
        NSLog(@"%@",error);
    };

    
    NSString *methodStr = (method == GET) ? @"GET" : @"POST";
    [[self dataTaskWithHTTPMethod:methodStr URLString:UrlString parameters:parameters uploadProgress:nil downloadProgress:nil success:successBlock failure:errorBlock] resume] ;
    
}





@end
