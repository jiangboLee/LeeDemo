//
//  GSDetailContent.m
//  gushici
//
//  Created by 李江波 on 2017/2/13.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSDetailContent.h"
#import "GSGushiContentModel.h"

@interface GSDetailContent ()


@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *chaodai;


@end

@implementation GSDetailContent

-(void)awakeFromNib{

    [super awakeFromNib];
    self.nameStr.font = [UIFont fontWithName:_FontName size:_Font(28)];
    self.author.font = [UIFont fontWithName:_FontName size:_Font(16)];
    self.chaodai.font = [UIFont fontWithName:_FontName size:_Font(16)];
    self.cont.font = [UIFont fontWithName:_FontName size:_Font(22)];
}

-(void)setGushi:(GSGushiContentModel *)gushi{

    _gushi = gushi;
    self.nameStr.text = gushi.nameStr;
    self.author.text = [NSString stringWithFormat:@"作者: %@",gushi.author];
    self.chaodai.text = [NSString stringWithFormat:@"朝代: %@",gushi.chaodai];
    
    NSString *cont0 = [gushi.cont stringByReplacingOccurrencesOfString:@"\n\n" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"\n<br />\n" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"。" withString:@"。\n"];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"." withString:@"。\n"];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"¤" withString:@"。"];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"<span style=\"font-family:KaiTi_GB2312;\">" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"<div class=\"xhe-paste\" style=\"top: 0px;\">" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"</strong>" withString:@" "];
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"<strong>" withString:@" "];
    if (self.mingju == nil || ![cont0 containsString:self.mingju]) {
        
        self.cont.text = cont0;
    }else{
    
        NSRange range = [cont0 rangeOfString:self.mingju];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cont0];
            
        [str addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:range];
        self.cont.attributedText = str;
    }
    
    [self layoutIfNeeded];
    
}
-(void)layoutSubviews{

    [super layoutSubviews];
    if (self.heightBlock != nil ) {
        
        self.heightBlock(CGRectGetMaxY(self.cont.frame));
    }
}

@end
