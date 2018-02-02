//
//  GSHistoryTableVC.m
//  gushici
//
//  Created by 李江波 on 2017/2/21.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSHistoryTableVC.h"
#import "GSSQLiteTools.h"
#import "GSGushiContentModel.h"
#import "GSBaseTableViewCell.h"
#import "GSDetailController.h"

@interface GSHistoryTableVC ()<UITableViewDelegate ,UITableViewDataSource>

@property(nonatomic ,strong) NSMutableArray<GSGushiContentModel *> *dataArray;
@property(nonatomic ,strong) UITableView *tableV;

@end
static NSString *baseTableCellID = @"baseTableCellID";
@implementation GSHistoryTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableV = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableV];
    
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.rowHeight = 100;
    tableV.tableFooterView = [[UIView alloc]init];
    
    [tableV registerNib:[UINib nibWithNibName:@"GSBaseTableViewCell" bundle:nil] forCellReuseIdentifier:baseTableCellID];
    self.tableV = tableV;
    
    if (!self.isLikeHistory) {
        self.title = @"浏览记录";
        UIBarButtonItem *deleteAll = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAll)];
        self.navigationItem.rightBarButtonItem = deleteAll;
        [deleteAll setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:_FontName size:17],NSForegroundColorAttributeName :[UIColor redColor]} forState:UIControlStateNormal];
    } else {
        self.title = @"我的收藏";
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GSBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseTableCellID forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    GSDetailController *vc = [[GSDetailController alloc]init];
    
    vc.gushiID = self.dataArray[indexPath.row].gushiID;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    NSMutableArray *arrayM = [NSMutableArray array];
    if (self.isLikeHistory) {
        
        [[GSSQLiteTools shared].queue inDatabase:^(FMDatabase *db) {
            
            FMResultSet *result = [db executeQuery:@"SELECT * FROM t_likegushi ORDER BY time DESC"];
            
            while (result.next) {
                
                NSData *data = [result dataForColumn:@"name"];
                GSGushiContentModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                [arrayM addObject:model];
            }
            
        }];
    }else{
        
        [[GSSQLiteTools shared].queue inDatabase:^(FMDatabase *db) {
            
            FMResultSet *result = [db executeQuery:@"SELECT * FROM t_gushi ORDER BY time DESC"];
            
            while (result.next) {
                
                NSData *data = [result dataForColumn:@"name"];
                GSGushiContentModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                [arrayM addObject:model];
            }
            
        }];
    }
    self.dataArray = arrayM;
    [self.tableV reloadData];
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.isLikeHistory) {
        
        GSGushiContentModel *model = self.dataArray[indexPath.row];
        NSString *sql = @"DELETE FROM t_likegushi WHERE gushiID = ?";
        [[GSSQLiteTools shared].queue inDatabase:^(FMDatabase *db) {
            
            [db executeUpdate:sql withArgumentsInArray:@[@(model.gushiID)]];
        }];
        
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableV reloadData];
    }else{
        
        GSGushiContentModel *model = self.dataArray[indexPath.row];
        NSString *sql = @"DELETE FROM t_gushi WHERE gushiID = ?";
        [[GSSQLiteTools shared].queue inDatabase:^(FMDatabase *db) {
            
            [db executeUpdate:sql withArgumentsInArray:@[@(model.gushiID)]];
        }];
        
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableV reloadData];
        
    }
    
}
//删除全部
-(void)deleteAll{

    NSString *sql = @"DELETE FROM t_gushi";
    [[GSSQLiteTools shared].queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:sql];
    }];
    
    [self.dataArray removeAllObjects];
    [self.tableV reloadData];
}


@end
