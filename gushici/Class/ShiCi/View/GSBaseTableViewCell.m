//
//  GSBaseTableViewCell.m
//  gushici
//
//  Created by 李江波 on 2017/2/14.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSBaseTableViewCell.h"
#import "GSGushiContentModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GSBaseTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *pic;

@property (weak, nonatomic) IBOutlet UILabel *nameStr;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *cont;

@end

@implementation GSBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setModel:(GSGushiContentModel *)model{

    _model = model;
    self.nameStr.text = model.nameStr;
    self.author.text = [NSString stringWithFormat:@"作者: %@",model.author];
    self.cont.text = model.cont;
    
    NSString *picName = model.author.transformToPinyin;
    picName = [NSString stringWithFormat:@"http://img.gushiwen.org/authorImg/%@.jpg",picName];
    
    [self.pic sd_setImageWithURL:[NSURL URLWithString:picName]];
}


@end
