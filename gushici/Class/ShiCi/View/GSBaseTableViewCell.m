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
    if (self.isAuthor) {
       self.author.text = [NSString stringWithFormat:@"朝代: %@",model.chaodai];
        NSString *picName = model.nameStr.transformToPinyin;
        picName = [NSString stringWithFormat:@"http://img.gushiwen.org/authorImg/%@.jpg",picName];
        
        [self.pic sd_setImageWithURL:[NSURL URLWithString:picName]];
    }else{
    
        self.author.text = [NSString stringWithFormat:@"作者: %@",model.author];
        NSString *picName = model.author.transformToPinyin;
        picName = [NSString stringWithFormat:@"http://img.gushiwen.org/authorImg/%@.jpg",picName];
        
        [self.pic sd_setImageWithURL:[NSURL URLWithString:picName]];
    }
    NSString *cont_0 = [model.cont stringByReplacingOccurrencesOfString:@"\n\n" withString:@""];
    NSString *cont0 = [cont_0 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *cont1 = [cont0 stringByReplacingOccurrencesOfString:@"\n<br />\n" withString:@""];
    NSString *cont3 = [cont1 stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    NSString *cont4 = [cont3 stringByReplacingOccurrencesOfString:@"." withString:@"。"];
    NSString *cont5 = [cont4 stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    NSString *cont6 = [cont5 stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    NSString *cont7 = [cont6 stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    NSString *cont8 = [cont7 stringByReplacingOccurrencesOfString:@"¤" withString:@"。"];
    self.cont.text = cont8;
   
}


@end
