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

@property (weak, nonatomic) IBOutlet UITextView *cont1;
@end

@implementation GushiContent

+(instancetype)gushiContent{
    return [[[UINib nibWithNibName:@"GushiContent" bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
}

-(void)awakeFromNib{

    [super awakeFromNib];
    [_cont1 layoutIfNeeded];
    _cont1.layoutManager.allowsNonContiguousLayout = false;
    [_cont1 scrollRangeToVisible:NSMakeRange(0, 1)];
    
}


-(void)setModel:(GSGushiContentModel *)model{

    _model = model;
    //标题处理
   
    self.title.text = model.nameStr;
    //内容处理
//    [self.cont1 setContentOffset:CGPointZero animated:NO];
    NSString *cont1 = [model.cont stringByReplacingOccurrencesOfString:@"\n<br />\n" withString:@""];
    NSString *cont2 = [cont1 stringByReplacingOccurrencesOfString:@"。" withString:@"。\n"];
    NSString *cont3 = [cont2 stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    NSString *cont4 = [cont3 stringByReplacingOccurrencesOfString:@"." withString:@"。\n"];
    NSString *cont5 = [cont4 stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    NSString *cont6 = [cont5 stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    NSString *cont7 = [cont6 stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    NSString *cont8 = [cont7 stringByReplacingOccurrencesOfString:@"¤" withString:@"。"];
    self.cont1.text = cont8;
}




@end
