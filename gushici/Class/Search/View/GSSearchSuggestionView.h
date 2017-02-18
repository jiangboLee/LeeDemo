//
//  GSSearchSuggestionView.h
//  gushici
//
//  Created by 李江波 on 2017/2/12.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSGushiContentModel;

typedef NS_ENUM(NSUInteger, didSelecteType) {
    didSelecteTypeShiwen,
    didSelecteTypeMingju,
    didSelecteTypeAuthor,
    didSelecteTypeLeixing
};

@protocol GSSearchSuggestionViewDelegat <NSObject>

-(void)searchSuggestionViewDidSelecteType:(didSelecteType)type model:(GSGushiContentModel *)model iid:(NSInteger)iid;

@end

@interface GSSearchSuggestionView : UITableViewCell

@property(nonatomic ,copy) NSString *searchText;
@property(nonatomic ,strong) NSDictionary *dict;

@property(nonatomic ,weak) id<GSSearchSuggestionViewDelegat> delegate;

@end
