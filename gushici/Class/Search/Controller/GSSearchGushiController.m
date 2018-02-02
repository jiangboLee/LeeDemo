//
//  GSSearchGushiController.m
//  gushici
//
//  Created by 李江波 on 2017/2/18.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSSearchGushiController.h"
#import "GSGushiContentModel.h"
#import "GSDetailController.h"
#import "GSBaseTableViewCell.h"
#import "GSAuthorDetailController.h"

@interface GSSearchGushiController ()
@property(nonatomic ,strong) NSMutableArray<GSGushiContentModel *> *dataArray;
@property(nonatomic ,assign) NSInteger page;
@property(nonatomic ,strong) GSDetailController *detailVC;
@property(nonatomic ,assign) BOOL isRefreshUP;

@property(nonatomic ,strong) GSGushiContentModel *authorModel;

@end

static NSString *baseTableCellID = @"baseTableCellID";
@implementation GSSearchGushiController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENW, 44)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GSBaseTableViewCell" bundle:nil] forCellReuseIdentifier:baseTableCellID];
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
}
-(void)loadData {

    if ([self.type isEqualToString:@"author"] && !self.isRefreshUP) {
        
        NSString *url = [NSString stringWithFormat:@"http://app.gushiwen.org/api/author/authorForName.aspx?n=868654231&token=gswapi&nameStr=%@",self.searchStr];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[LEEHTTPManager share] request:GET UrlString:url parameters:nil finshed:^(NSDictionary *responseObject, NSError *error) {
            if (error != nil) {
                [SVProgressHUD showErrorWithStatus:@"网络有问题"];
                return ;
            }
            
            GSGushiContentModel *model = [GSGushiContentModel yy_modelWithDictionary:responseObject];
            if (model.nameStr == nil) {
                [self loadData2];
                return;
            }
            self.authorModel = model;
            [self loadData2];
        }];
    }else{
    
        [self loadData2];
    }
    
}
-(void)loadData2{
    //c:朝代 t:类型 x：形式
    NSString *urlStr = [NSString stringWithFormat:@"http://app.gushiwen.org/api/search.aspx?n=3985169987&page=%zd&value=%@&type=%@&token=gswapi",self.page, self.searchStr, self.type];//
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(self) weakSelf = self;
    [[LEEHTTPManager share] request:GET UrlString:urlStr parameters:nil finshed:^(NSDictionary *responseObject, NSError *error) {
        
        if (error != nil) {
            
            [SVProgressHUD showErrorWithStatus:@"网络有问题"];
            return ;
        }
        if ([responseObject[@"sumCount"] integerValue] == 0) {
            
            [SVProgressHUD showInfoWithStatus:@"该筛选没结果哦"];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
        
        
        NSArray *array = [NSArray yy_modelArrayWithClass:[GSGushiContentModel class] json:responseObject[@"gushiwens"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.isRefreshUP) {
                
                [weakSelf.dataArray addObjectsFromArray:array];
            }else{
                
                [weakSelf.dataArray removeAllObjects];
                if (self.authorModel != nil) {
                    
                    [self.dataArray insertObject:self.authorModel atIndex:0];
                }
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
    if (self.authorModel != nil && indexPath.row == 0) {
        cell.isAuthor = YES;
        cell.isSearchAuthor = YES;
    }else{
    
        cell.isAuthor = NO;
        cell.isSearchAuthor = NO;
    }
    cell.searchStr = self.searchStr;
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.authorModel != nil && indexPath.row == 0) {
        
        GSAuthorDetailController *authorVC = [[GSAuthorDetailController alloc]init];
        authorVC.model = self.authorModel;
        [self.navigationController pushViewController:authorVC animated:YES];
    }else{
    
        GSDetailController *gushiVC = [[GSDetailController alloc]init];
        gushiVC.gushiID = self.dataArray[indexPath.row].gushiID;
        [self.navigationController pushViewController:gushiVC animated:YES];
    }
}

@end
