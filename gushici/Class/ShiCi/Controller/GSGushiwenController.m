//
//  GSGushiwenController.m
//  gushici
//
//  Created by 李江波 on 2017/2/14.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSGushiwenController.h"
#import "GSGushiContentModel.h"
#import "GSBaseTableViewCell.h"
#import "GSDetailController.h"

@interface GSGushiwenController ()<UIViewControllerPreviewingDelegate>

@property(nonatomic ,strong) NSMutableArray<GSGushiContentModel *> *dataArray;

@property(nonatomic ,assign) NSInteger page;

@property(nonatomic ,strong) GSDetailController *detailVC;

@property(nonatomic ,copy) NSString *chaodai;
@property(nonatomic ,copy) NSString *xingshi;

@property(nonatomic ,assign) BOOL isRefreshUP;

@end

static NSString *baseTableCellID = @"baseTableCellID";
@implementation GSGushiwenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENW, 44)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GSBaseTableViewCell" bundle:nil] forCellReuseIdentifier:baseTableCellID];
    if (!self.isLeixingSearch) {
        self.leixing = @"不限";
    }
    self.chaodai = @"不限";
    self.xingshi = @"不限";
    [[NSUserDefaults standardUserDefaults] setObject:self.leixing forKey:@"lable1"];
    [[NSUserDefaults standardUserDefaults] setObject:self.chaodai forKey:@"lable2"];
    [[NSUserDefaults standardUserDefaults] setObject:self.xingshi forKey:@"lable3"];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tRUECLICKNotificationName:) name:TRUECLICKNotificationName object:nil];
}
-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)tRUECLICKNotificationName:(NSNotification *)notification{

    self.leixing = notification.userInfo[TRUECLICKNotificationNameKey][0];
    self.chaodai = notification.userInfo[TRUECLICKNotificationNameKey][1];
    self.xingshi = notification.userInfo[TRUECLICKNotificationNameKey][2];
    
    [self.tableView.mj_header beginRefreshing];
}
-(void)loadData{
    
    if ([self.chaodai isEqualToString:@"不限"]) {
        self.chaodai = @"";
    }
    if ([self.leixing isEqualToString:@"不限"]) {
        self.leixing = @"";
    }
    if ([self.xingshi isEqualToString:@"不限"]) {
        self.xingshi = @"";
    }
    
    
    //c:朝代 t:类型 x：形式
    NSString *urlStr = [NSString stringWithFormat:@"http://app.gushiwen.org/api/shiwen/type.aspx?n=1665121346&page=%zd&pwd=&id=0&token=gswapi&c=%@&p=%zd&x=%@&t=%@",self.page, self.chaodai, self.page, self.xingshi, self.leixing];//@"http://app.gushiwen.org/api/shiwen/type.aspx?n=1665121346&page=1&pwd=&id=0&token=gswapi&c=%@&p=1&x=&t=%E5%A4%8F%E5%A4%A9";
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
    cell.isAuthor = NO;
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GSGushiContentModel *model = self.dataArray[indexPath.row];
    _detailVC = [[GSDetailController alloc]init];
    _detailVC.gushiID = model.gushiID;
    [self.navigationController pushViewController:_detailVC animated:YES];
}
#pragma mark: - 3dTouch
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    [self showViewController:viewControllerToCommit sender:self];
}
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)previewingContext.sourceView];
    GSGushiContentModel *model = self.dataArray[indexPath.row];
    _detailVC = [[GSDetailController alloc]init];
    _detailVC.preferredContentSize = CGSizeMake(0, 500);
    _detailVC.gushiID = model.gushiID;
    return _detailVC;
}


@end
