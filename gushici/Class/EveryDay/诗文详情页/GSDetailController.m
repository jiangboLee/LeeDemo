//
//  GSDetailController.m
//  gushici
//
//  Created by 李江波 on 2017/2/13.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSDetailController.h"
#import "GSGushiContentModel.h"
#import "GSDetailContent.h"

@interface GSDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong) UITableView *tableV;
@property(nonatomic ,strong) GSDetailContent *headerView;

@end

static NSString *tableV_cellID = @"tableV_cellID";
@implementation GSDetailController

-(GSDetailContent *)headerView{

    if (_headerView == nil) {
        
        _headerView = [[[UINib nibWithNibName:@"GSDetailContent" bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
    }
    return _headerView;
}

-(UITableView *)tableV{

    if (_tableV == nil) {
        _tableV = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        [_tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:tableV_cellID];
        
        _tableV.delegate = self;
        _tableV.dataSource = self;
        
        [self.view addSubview:_tableV];

    }
    return _tableV;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTableview];
}

-(void)setTableview{
    
 
    
    
}

-(void)setDataArray:(NSArray *)dataArray{

    _dataArray = dataArray;
    
    __weak typeof(self) weakSelf = self;
    [self.headerView setHeightBlock:^(CGFloat x) {
        
        weakSelf.headerView.ljb_height = x - 44;
        NSLog(@"%f",x);
        weakSelf.tableV.tableHeaderView = weakSelf.headerView;
    }];
    self.headerView.gushi = dataArray[0];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableV_cellID forIndexPath:indexPath];
    
    return cell;
}





@end
