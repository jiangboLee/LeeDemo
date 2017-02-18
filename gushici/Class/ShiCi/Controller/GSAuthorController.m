//
//  GSAuthorController.m
//  gushici
//
//  Created by 李江波 on 2017/2/14.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSAuthorController.h"
#import "GSGushiContentModel.h"
#import "GSBaseTableViewCell.h"
#import "GSAuthorDetailController.h"

@interface GSAuthorController ()

@property(nonatomic ,strong) NSMutableArray<GSGushiContentModel *> *dataArray;

@property(nonatomic ,assign) NSInteger page;
@property(nonatomic ,assign) BOOL isRefreshUP;
@property(nonatomic ,copy) NSString *chaodai;

@end

static NSString *baseTableCellID = @"baseTableCellID";
@implementation GSAuthorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENW, 44)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GSBaseTableViewCell" bundle:nil] forCellReuseIdentifier:baseTableCellID];
    
    self.chaodai = @"不限";
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        
        [self loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page ++ ;
        self.isRefreshUP = YES;
        [self loadData];
        
    }];
    self.tableView.mj_footer.hidden = YES;
    
    [self setNotification];
}

-(void)setNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tRUECLICKNotificationName:) name:AUTHORCLICKNotificationName object:nil];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)tRUECLICKNotificationName:(NSNotification *)notification{
    
    self.chaodai = notification.userInfo[AUTHORCLICKNotificationNameKey];
    
    [self.tableView.mj_header beginRefreshing];
}


-(void)loadData{
    
    //c:朝代 t:类型 x：形式
    NSString *urlStr = [NSString stringWithFormat:@"http://app.gushiwen.org/api/author/Default.aspx?n=2394374691&page=%zd&pwd=&id=0&token=gswapi&c=%@&p=%zd",self.page, self.chaodai, self.page];//@"http://app.gushiwen.org/api/shiwen/type.aspx?n=1665121346&page=1&pwd=&id=0&token=gswapi&c=%@&p=1&x=&t=%E5%A4%8F%E5%A4%A9";
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(self) weakSelf = self;
    [[LEEHTTPManager share] request:GET UrlString:urlStr parameters:nil finshed:^(NSDictionary *responseObject, NSError *error) {
        
        if (error != nil) {
            
            [self showHint:@"网络有问题"];
            return ;
        }
        if ([responseObject[@"sumCount"] integerValue] == 0) {
            
            [self showHint:@"该筛选没结果哦"];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
        
        
        NSArray *array = [NSArray yy_modelArrayWithClass:[GSGushiContentModel class] json:responseObject[@"authors"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.isRefreshUP) {
                
                [weakSelf.dataArray addObjectsFromArray:array];
            }else{
                
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.dataArray addObjectsFromArray:array];
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
            self.isRefreshUP = NO;
            
            self.tableView.mj_footer.hidden = [responseObject[@"sumCount"] integerValue] == self.dataArray.count;
            
        });
        
    }];
    
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GSBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseTableCellID forIndexPath:indexPath];
    cell.isAuthor = YES;
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GSAuthorDetailController *vc = [[GSAuthorDetailController alloc]init];
    vc.model = self.dataArray[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
