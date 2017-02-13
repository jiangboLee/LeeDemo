//
//  GSSearchSuggestionView.h
//  gushici
//
//  Created by 李江波 on 2017/2/12.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSSearchSuggestionView : UITableViewCell

@property(nonatomic ,copy) NSString *searchText;
@property(nonatomic ,strong) NSDictionary *dict;

@end
