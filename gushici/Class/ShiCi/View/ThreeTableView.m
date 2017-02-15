//
//  ThreeTableView.m
//  gushici
//
//  Created by 李江波 on 2017/2/15.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "ThreeTableView.h"

@interface ThreeTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *table1;
@property (weak, nonatomic) IBOutlet UITableView *table2;
@property (weak, nonatomic) IBOutlet UITableView *table3;
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UILabel *lable2;
@property (weak, nonatomic) IBOutlet UILabel *lable3;

@end

static NSString *table1CellID = @"table1CellID";
static NSString *table2CellID = @"table2CellID";
static NSString *table3CellID = @"table3CellID";
@implementation ThreeTableView

-(void)awakeFromNib{

    [super awakeFromNib];
    
    [_table1 registerClass:[UITableViewCell class] forCellReuseIdentifier:table1CellID];
    [_table2 registerClass:[UITableViewCell class] forCellReuseIdentifier:table2CellID];
    [_table3 registerClass:[UITableViewCell class] forCellReuseIdentifier:table3CellID];
    
    _table3.tableFooterView = [[UIView alloc]init];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([tableView isEqual:_table1]) {
        
        return self.table1Array.count;
    }else if ([tableView isEqual:_table2]){
    
        return self.table2Array.count;
    }else{
    
        return self.table3Array.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:_table1]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:table1CellID forIndexPath:indexPath];
        
        cell.textLabel.text = self.table1Array[indexPath.row];
        
        return cell;
    }else if ([tableView isEqual:_table2]){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:table2CellID forIndexPath:indexPath];
        
        cell.textLabel.text = self.table2Array[indexPath.row];
        
        return cell;
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:table3CellID forIndexPath:indexPath];
        
        cell.textLabel.text = self.table3Array[indexPath.row];
        
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([tableView isEqual:_table1]) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.lable1.text = cell.textLabel.text;
        
    }else if ([tableView isEqual:_table2]){
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.lable2.text = cell.textLabel.text;
    }else{
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.lable3.text = cell.textLabel.text;
    }
    
}

- (IBAction)clickTrueAction:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:TRUECLICKNotificationName object:self userInfo:@{TRUECLICKNotificationNameKey: @[self.lable1.text,self.lable2.text,self.lable3.text]}];
    
}

@end
