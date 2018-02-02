//
//  GSAuthorTableViewCell.m
//  gushici
//
//  Created by ljb48229 on 2018/2/2.
//  Copyright © 2018年 lijiangbo. All rights reserved.
//

#import "GSAuthorTableViewCell.h"

@interface GSAuthorTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;


@end

@implementation GSAuthorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title.font = [UIFont fontWithName:_FontName size:_Font(20)];
    self.contentLable.font = [UIFont fontWithName:_FontName size:_Font(18)];
    self.contentLable.textColor = [UIColor cz_colorWithRed:30 green:30 blue:30];
    [self.contentView insertSubview:self.needMoreButton aboveSubview:self.contentLable];
}

- (void)setModel:(GSGushiContentModel *)model {
    _model = model;
    self.title.text = model.nameStr;
    NSString *contentStr = model.cont;
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"</strong><br />" withString:@": "];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<span style=\"font-family:SimSun;\">" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<br />" withString:@":"];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<span style=\"font-family:FangSong_GB2312;\">" withString:@""];
    self.contentLable.text = contentStr;
    
    [UILabel changeSpaceForLabel:self.title withLineSpace:5 WordSpace:2];
    [UILabel changeSpaceForLabel:self.contentLable withLineSpace:5 WordSpace:2];
}

- (IBAction)lookMoreClickAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (self.lookMoreClickBlock) {
        self.lookMoreClickBlock(sender.selected);
    }
}

@end
