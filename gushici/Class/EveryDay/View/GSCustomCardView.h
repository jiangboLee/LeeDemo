//
//  GSCustomCardView.h
//  gushici
//
//  Created by 李江波 on 2017/2/12.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "CCDraggableCardView.h"
@class GSGushiContentModel;

@interface GSCustomCardView : CCDraggableCardView

- (void)installData:(GSGushiContentModel *)element;

@end
