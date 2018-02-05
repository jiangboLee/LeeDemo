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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleRightConstraint;

//播放器
@property(nonatomic ,assign) BOOL isStop;
@end

@implementation GSDetailContent

-(void)awakeFromNib{

    [super awakeFromNib];
    [UILabel changeLineSpaceForLabel:self.cont WithSpace:8];
    self.nameStr.font = [UIFont fontWithName:_FontName size:_Font(28)];
    self.author.font = [UIFont fontWithName:_FontName size:_Font(16)];
    self.chaodai.font = [UIFont fontWithName:_FontName size:_Font(16)];
    self.cont.font = [UIFont fontWithName:_FontName size:_Font(22)];
}

-(void)setGushi:(GSGushiContentModel *)gushi{

    _gushi = gushi;
    //设置录音
    if(gushi.langsongAuthorPY.length > 0){
    
        self.videoBotton.hidden = NO;
        self.titleRightConstraint.constant = 40;
    }else{
    
        self.videoBotton.hidden = YES;
        self.titleRightConstraint.constant = 20;
    }
    
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
    
    cont0 = [cont0 stringByReplacingOccurrencesOfString:@"<span style=\"font-family:SimSun;\">" withString:@""];
    
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

//******************************************************************//
//播放声音

- (IBAction)playVideoAction:(UIButton *)sender {
    
    if (!sender.selected && !self.isStop) {
        
        if (self.videoPlayBlock != nil) {
            self.videoPlayBlock(videoPlayTypeFirst);
        }
        sender.selected = YES;
    }else if (sender.selected){

        if (self.videoPlayBlock != nil) {
            self.videoPlayBlock(videoPlayTypePause);
        }
        sender.selected = NO;
        self.isStop = YES;
    }else{

        if (self.videoPlayBlock != nil) {
            self.videoPlayBlock(videoPlayTypeGoOn);
        }
        sender.selected = YES;
    }

}



@end
