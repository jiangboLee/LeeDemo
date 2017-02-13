//
//  GSSearchSuggestionView.m
//  gushici
//
//  Created by 李江波 on 2017/2/12.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSSearchSuggestionView.h"

@interface GSSearchSuggestionView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

static NSString *cellId = @"gushiCell";
@implementation GSSearchSuggestionView

-(void)awakeFromNib{

    [super awakeFromNib];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

-(void)setDict:(NSDictionary *)dict{

    _dict = dict;
    
    NSString *title = [[dict allKeys] lastObject];
    if ([title isEqualToString:@"gushiwens"]) {
        
       self.titleLable.text = @"诗文";
    }else if ([title isEqualToString:@"mingjus"]) {
    
        self.titleLable.text = @"名句";
    }else if ([title isEqualToString:@"authors"]) {
    
        self.titleLable.text = @"作者";
    }else if ([title isEqualToString:@"typekeys"]){
    
        self.titleLable.text = @"类型";
    }else{
        
        self.titleLable.text = dict[title];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    return cell;
}



@end
