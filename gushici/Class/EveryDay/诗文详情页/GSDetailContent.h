//
//  GSDetailContent.h
//  gushici
//
//  Created by 李江波 on 2017/2/13.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, videoPlayType) {
    videoPlayTypeFirst,
    videoPlayTypePause,
    videoPlayTypeGoOn
};

@class GSGushiContentModel;
@interface GSDetailContent : UIView

@property(nonatomic ,strong) GSGushiContentModel *gushi;

@property (weak, nonatomic) IBOutlet UILabel *cont;
@property (weak, nonatomic) IBOutlet UILabel *nameStr;

@property(nonatomic ,copy) void(^heightBlock)(CGFloat height);
@property(nonatomic ,copy) NSString *mingju;

@property(nonatomic ,copy) void(^videoPlayBlock)(videoPlayType type);
@property (weak, nonatomic) IBOutlet UIButton *videoBotton;
@end
