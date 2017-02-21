//
//  GushiContent.m
//  gushici
//
//  Created by 李江波 on 2017/2/12.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GushiContent.h"
#import "GSGushiContentModel.h"

@interface GushiContent ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *authorLable;

@property (weak, nonatomic) IBOutlet UITextView *cont1;
@end

@implementation GushiContent

+(instancetype)gushiContent{
    return [[[UINib nibWithNibName:@"GushiContent" bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
}

-(void)awakeFromNib{

    [super awakeFromNib];
    [UITextView changeLineSpaceForLabel:self.cont1 WithSpace:10];
    [_cont1 layoutIfNeeded];
    _cont1.layoutManager.allowsNonContiguousLayout = false;
    [_cont1 scrollRangeToVisible:NSMakeRange(0, 1)];
    
    self.title.font = [UIFont fontWithName:_FontName size:_Font(28)];
    self.authorLable.font = [UIFont fontWithName:_FontName size:_Font(16)];
    self.cont1.font = [UIFont fontWithName:_FontName size:_Font(20)];
}


-(void)setModel:(GSGushiContentModel *)model{

    _model = model;
    //标题处理
   
    self.title.text = model.nameStr;
    self.authorLable.text = [NSString stringWithFormat:@"作者: %@",model.author];
    //内容处理
//    [self.cont1 setContentOffset:CGPointZero animated:NO];
    NSString *cont0 = [model.cont stringByReplacingOccurrencesOfString:@"\n\n" withString:@""];
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
    
    self.cont1.text = cont0;
}




@end
