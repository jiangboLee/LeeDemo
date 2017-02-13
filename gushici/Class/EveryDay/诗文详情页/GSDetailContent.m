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

@property (weak, nonatomic) IBOutlet UILabel *nameStr;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *chaodai;
@property (weak, nonatomic) IBOutlet UILabel *cont;

@end

@implementation GSDetailContent


-(void)setGushi:(GSGushiContentModel *)gushi{

    _gushi = gushi;
    self.nameStr.text = gushi.nameStr;
    self.author.text = [NSString stringWithFormat:@"作者: %@",gushi.author];
    self.chaodai.text = [NSString stringWithFormat:@"朝代: %@",gushi.chaodai];
    
    NSString *cont1 = [gushi.cont stringByReplacingOccurrencesOfString:@"\n<br />\n" withString:@""];
    NSString *cont2 = [cont1 stringByReplacingOccurrencesOfString:@"。" withString:@"。\n"];
    NSString *cont3 = [cont2 stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    NSString *cont4 = [cont3 stringByReplacingOccurrencesOfString:@"." withString:@"。\n"];
    NSString *cont5 = [cont4 stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    NSString *cont6 = [cont5 stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    NSString *cont7 = [cont6 stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    NSString *cont8 = [cont7 stringByReplacingOccurrencesOfString:@"¤" withString:@"。"];
    self.cont.text = cont8;
}

@end
