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

#import "RemarksTableViewCell.h"
#import "RemarksCellHeightModel.h"

@interface GSDetailController ()<UITableViewDelegate,UITableViewDataSource,RemarksCellDelegate>

@property(nonatomic ,strong) UITableView *tableV;
@property(nonatomic ,strong) GSDetailContent *headerView;

// 存放cell视图展开状态的字典
@property (nonatomic, strong) NSMutableDictionary *cellIsShowAll;

@end

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
        
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.tableFooterView = [[UIView alloc]init];
        
        [self.view addSubview:_tableV];

    }
    return _tableV;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.cellIsShowAll = [NSMutableDictionary dictionary];
}


-(void)setDataArray:(NSArray *)dataArray{

    _dataArray = dataArray;
    
    __weak typeof(self) weakSelf = self;
    [self.headerView setHeightBlock:^(CGFloat x) {
        
        weakSelf.headerView.ljb_height = x ;
       
        weakSelf.tableV.tableHeaderView = weakSelf.headerView;
    }];
    self.headerView.gushi = dataArray[0];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return self.dataArray.count - 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellName = @"meTableViewCell";
    RemarksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[RemarksTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GSGushiContentModel *model = [self.dataArray objectAtIndex:indexPath.row + 1];
    
    if (model.shiID) {
        cell.infolable.text = model.nameStr;
    }else{
    
        cell.infolable.text = @"作者";
    }
    
    [cell setCellContent:model.cont andIsShow:[[self.cellIsShowAll objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]] boolValue]  andCellIndexPath:indexPath];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回Cell高度
    
    GSGushiContentModel *model = [self.dataArray objectAtIndex:indexPath.row + 1];
    return [RemarksCellHeightModel cellHeightWith:model.cont andIsShow:[[self.cellIsShowAll objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]] boolValue] andLableWidth:[UIScreen mainScreen].bounds.size.width-30 andFont:_Font(16) andDefaultHeight:52 andFixedHeight:42 andIsShowBtn:8];
}

#pragma mark -- Dalegate
- (void)remarksCellShowContrntWithDic:(NSDictionary *)dic andCellIndexPath:(NSIndexPath *)indexPath
{
    [self.cellIsShowAll setObject:[dic objectForKey:@"isShow"] forKey:[NSString stringWithFormat:@"%@",[dic objectForKey:@"row"]]];
    
    [_tableV reloadData];
}





@end
