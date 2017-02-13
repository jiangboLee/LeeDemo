//
//  GSSearchSuggestionView.m
//  gushici
//
//  Created by 李江波 on 2017/2/12.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSSearchSuggestionView.h"
#import "GSSearchEditModel.h"

@interface GSSearchSuggestionView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic ,weak) NSArray *models;

@end

static NSString *cellId = @"gushiCell";
@implementation GSSearchSuggestionView

-(void)awakeFromNib{

    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor cz_randomColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.scrollEnabled = NO;
}

-(void)setDict:(NSDictionary *)dict{

    _dict = dict;
    
    NSString *title = [[dict allKeys] lastObject];
    self.models = (NSArray *)dict[title];
    if ([title isEqualToString:@"gushiwens"]) {
        
       self.titleLable.text = @"诗文";
    }else if ([title isEqualToString:@"mingjus"]) {
    
        self.titleLable.text = @"名句";
    }else if ([title isEqualToString:@"authors"]) {
    
        self.titleLable.text = @"作者";
    }else if ([title isEqualToString:@"typekeys"]){
    
        self.titleLable.text = @"类型";
    }else{
        
        self.titleLable.text = @"结果";
    }
    
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GSSearchEditModel *model = (GSSearchEditModel *)self.models[indexPath.row];
    if (![self.titleLable.text isEqualToString:@"结果"]) {
        
        
        NSString *str;
        if (model.author != nil) {
            
            str = [NSString stringWithFormat:@"%@-%@",model.nameStr,model.author];
        }else{
        
            str = model.nameStr;
        }
        
        NSRange range = [str rangeOfString:self.searchText];
        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc]initWithString:str];
        [mutableStr addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:range];
        
        cell.textLabel.attributedText = mutableStr;
        
        
    }else{
    
        cell.textLabel.text = @"找不到结果哦";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"%zd",indexPath.row);
}

@end
