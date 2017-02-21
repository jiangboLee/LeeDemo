//
//  GSGushiContentModel.h
//  gushici
//
//  Created by 李江波 on 2017/2/12.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSGushiContentModel : NSObject<YYModel,NSCoding>

@property(nonatomic ,assign) NSInteger gushiID;
@property(nonatomic ,copy) NSString *nameStr;
@property(nonatomic ,copy) NSString *author;
@property(nonatomic ,copy) NSString *chaodai;
@property(nonatomic ,copy) NSString *cankao;

/**
 诗内容
 */
@property(nonatomic ,copy) NSString *cont;
@property(nonatomic ,copy) NSString *type;

/**
 朗诵作者
 */
@property(nonatomic ,copy) NSString *langsongAuthorPY;


@property(nonatomic ,copy) NSString *pic;
@property(nonatomic ,assign) NSInteger shiID;

@property(nonatomic ,assign) CGFloat rowHeight;

@property(nonatomic ,assign) BOOL isAreadlyRefresh;

@end
