//
//  GSCustomCardView.m
//  gushici
//
//  Created by 李江波 on 2017/2/12.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSCustomCardView.h"
#import "GSGushiContentModel.h"
#import "GushiContent.h"


@interface GSCustomCardView ()

@property(nonatomic ,strong) GushiContent *contentView;

@end

@implementation GSCustomCardView

-(instancetype)init{
    if (self = [super init]) {
        [self loadComponent];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadComponent];
    }
    return self;
}

-(void)loadComponent{
    
    _contentView = [GushiContent gushiContent];
    [self addSubview:_contentView];
    
    self.backgroundColor = [UIColor colorWithRed:0.951 green:0.951 blue:0.951 alpha:1.00];
}
-(void)cc_layoutSubviews{

    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}


-(void)installData:(GSGushiContentModel *)element{
    
    _contentView.model = element;
    _contentView.transform = CGAffineTransformIdentity;
}

@end
















