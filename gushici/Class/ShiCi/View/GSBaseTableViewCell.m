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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchHideConstrain;

@end

@implementation GSBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameStr.font = [UIFont fontWithName:_FontName size:_Font(16)];
    self.author.font = [UIFont fontWithName:_FontName size:_Font(13)];
    self.cont.font = [UIFont fontWithName:_FontName size:_Font(15)];
}
-(void)setModel:(GSGushiContentModel *)model{

    _model = model;
    if (self.searchStr != nil && [model.nameStr containsString:self.searchStr]) {
        NSRange range = [model.nameStr rangeOfString:self.searchStr];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:model.nameStr];
        
        [str addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:range];
        self.nameStr.attributedText = str;

    }else{
    
        self.nameStr.text = model.nameStr;
    }
    if (self.isAuthor) {
        if (!self.isSearchAuthor) {

            self.author.text = [NSString stringWithFormat:@"朝代: %@",model.chaodai];
        }else{
        
            self.author.hidden = YES;
            self.searchHideConstrain.constant = -5;
        }
        NSString *picName = model.nameStr.transformToPinyin;
        picName = [NSString stringWithFormat:@"http://img.gushiwen.org/authorImg/%@.jpg",picName];
        
        [self.pic sd_setImageWithURL:[NSURL URLWithString:picName] placeholderImage:[UIImage imageNamed:@"logo"]];
    }else{
        self.author.hidden = NO;
        self.searchHideConstrain.constant = 5;
        if (self.searchStr != nil && [model.author containsString:self.searchStr]) {
            NSRange range = [[NSString stringWithFormat:@"作者: %@",model.author] rangeOfString:self.searchStr];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"作者: %@",model.author]];
            
            [str addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:range];
            self.author.attributedText = str;
            
        }else{
            
            self.author.text = [NSString stringWithFormat:@"作者: %@",model.author];
        }
        NSString *picName = model.author.transformToPinyin;
        picName = [NSString stringWithFormat:@"http://img.gushiwen.org/authorImg/%@.jpg",picName];
        
        [self.pic sd_setImageWithURL:[NSURL URLWithString:picName] placeholderImage:[UIImage imageNamed:@"logo"]];
    }
    NSString *cont0 = [model.cont stringByReplacingOccurrencesOfString:@"\n\n" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"\n<br />\n" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"." withString:@"。"];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"¤" withString:@"。"];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"<span style=\"font-family:SimSun;\">" withString:@""];
    
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"</strong>" withString:@" "];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"<strong>" withString:@" "];
    
    if (self.searchStr != nil && [cont0 containsString:self.searchStr]) {
        NSRange range = [cont0 rangeOfString:self.searchStr];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cont0];
        
        [str addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:range];
        self.cont.attributedText = str;
        
    }else{
       
        self.cont.text = cont0;
    }

   
}


@end
