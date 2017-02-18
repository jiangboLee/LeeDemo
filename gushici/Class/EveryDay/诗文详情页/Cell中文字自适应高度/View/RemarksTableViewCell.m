//
//  RemarksTableViewCell.m
//  FlowerReceiveDemo
//
//  Created by Eyes on 16/2/19.
//  Copyright © 2016年 DuanGuoLi. All rights reserved.
//

#import "RemarksTableViewCell.h"

#define W            [UIScreen mainScreen].bounds.size.width

@interface RemarksTableViewCell ()

{
    NSIndexPath *_cellIndexPath;  // 当前Cell的下标
}

@end

@implementation RemarksTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self layoutUI];
    }
    return self;
}

- (void)setCellContent:(NSString *)contentStr andIsShow:(BOOL)isShow andCellIndexPath:(NSIndexPath *)indexPath
{
    
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    
    _textsLabel.text = contentStr;
    _cellIndexPath = indexPath;
    
     CGRect rect = [_textsLabel.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-30, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_textsLabel.font.pointSize]} context:nil];
    if (rect.size.height > 120) {
        // 文字大于三行，显示展开收起按钮
        self.moreBtn.hidden = NO;
        if (isShow) {
            _textsLabel.numberOfLines = 0;
            [_textsLabel mas_remakeConstraints:^(MASConstraintMaker *make){
                make.left.mas_equalTo(self.contentView.mas_left).offset(15);
                make.top.mas_equalTo(_infolable.mas_bottom).offset(5);
                make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width-30);
                make.height.mas_equalTo(rect.size.height + 2);
            }];
        } else {
            [_textsLabel mas_remakeConstraints:^(MASConstraintMaker *make){
                make.left.mas_equalTo(self.contentView.mas_left).offset(15);
                make.top.mas_equalTo(_infolable.mas_bottom).offset(5);
                make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width-30);
                make.height.mas_equalTo(70);
            }];
        }
    } else {
        // 文字小于三行，隐藏展开收起按钮
        _textsLabel.numberOfLines = 3;
        self.moreBtn.hidden = YES;
        [_textsLabel mas_remakeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.mas_equalTo(_infolable.mas_bottom).offset(5);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width-30);
            make.height.mas_equalTo(rect.size.height+1);  // 由于系统计算的那个高度有时候会有1像素到2像素的误差，所以这里把高度+1
        }];
    }
}

#pragma mark - 显示更多按钮点击事件
- (void)moreButtonClicked
{
    self.moreBtn.selected = !self.moreBtn.selected;
    if (self.moreBtn.selected) {
        [self.moreBtn setImage:[UIImage imageNamed:@"shq"] forState:UIControlStateNormal];
    }else{
        [self.moreBtn setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
    }
    
    // 记录当前按钮的选中状态，并传递给Controller
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:_cellIndexPath.row] forKey:@"row"];
    [dic setObject:[NSNumber numberWithBool:self.moreBtn.selected] forKey:@"isShow"];
    
    
    // 协议回调，改变Controller中存放Cell展开收起状态的字典
    if (self.delegate && [self.delegate respondsToSelector:@selector(remarksCellShowContrntWithDic:andCellIndexPath:)]) {
        [self.delegate remarksCellShowContrntWithDic:dic andCellIndexPath:_cellIndexPath];
    }
}

- (void)layoutUI
{
    _infolable = [[UILabel alloc]init];
//    _infolable.text = @"备注消息";
    _infolable.textColor = [UIColor blueColor];//CLColor(102, 102, 102);
    _infolable.font = [UIFont systemFontOfSize:_Font(16)];
    [self.contentView addSubview:_infolable];
    [_infolable mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width/2);
        make.height.mas_equalTo(12);
    }];
    
    _textsLabel = [[UILabel alloc]init];
//    _textsLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _textsLabel.numberOfLines = 3;
    _textsLabel.font = [UIFont systemFontOfSize:_Font(16)];
    _textsLabel.textColor = [UIColor cz_colorWithRed:30 green:30 blue:30];//CLColor(153, 153, 153);
    [self.contentView addSubview:_textsLabel];
    
    _moreBtn = [[UIButton alloc]init];
    [_moreBtn setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
    [_moreBtn setImage:[UIImage imageNamed:@"shq"] forState:UIControlStateHighlighted];
    [_moreBtn addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.contentView addSubview:_moreBtn];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.contentView.mas_left);
        make.top.mas_equalTo(_textsLabel.mas_bottom).offset(-10);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo(30);
    }];
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
