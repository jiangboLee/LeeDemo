//
//  GSMingjuController.m
//  gushici
//
//  Created by 李江波 on 2017/2/14.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSMingjuController.h"
#import "GSGushiContentModel.h"
#import "GSDetailController.h"

#import <CoreSpotlight/CoreSpotlight.h>

@interface GSMingjuController ()

@property(nonatomic ,strong) NSMutableArray<GSGushiContentModel *> *dataArray;

@property(nonatomic ,assign) NSInteger page;
@property(nonatomic ,assign) BOOL isRefreshUP;

@property(nonatomic ,copy) NSString *theme;
@property(nonatomic ,copy) NSString *leixing;

@end

static NSString *mingjuCellID = @"mingjuCellID";
@implementation GSMingjuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"CSSearchableBool"]) {
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
            [[CSSearchableIndex defaultSearchableIndex] deleteAllSearchableItemsWithCompletionHandler:^(NSError * _Nullable error) {
                
            }];
        }
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CSSearchableBool"];
    }
    
    self.dataArray = [NSMutableArray array];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENW, 44)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:mingjuCellID];
    
    self.leixing = @"不限";
    self.theme = @"不限";
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tRUECLICKNotificationName:) name:MINGJUCLICKNotificationName object:nil];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)tRUECLICKNotificationName:(NSNotification *)notification{
    
    self.theme = notification.userInfo[MINGJUCLICKNotificationNameKey][0];
    self.leixing = notification.userInfo[MINGJUCLICKNotificationNameKey][1];
    
    [self.tableView.mj_header beginRefreshing];
}


-(void)loadData{
    
    if ([self.leixing isEqualToString:@"不限"]) {
        self.leixing = @"";
    }
    if ([self.theme isEqualToString:@"不限"]) {
        self.theme = @"";
    }
    
    //c:朝代 t:类型 x：形式
    NSString *urlStr = [NSString stringWithFormat:@"http://app.gushiwen.org/api/mingju/Default.aspx?n=480237644&page=%zd&pwd=&id=0&token=gswapi&c=%@&p=%zd&t=%@",self.page, self.theme, self.page,self.leixing];
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
        
        
        NSArray *array = [NSArray yy_modelArrayWithClass:[GSGushiContentModel class] json:responseObject[@"mingjus"]];
        
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mingjuCellID forIndexPath:indexPath];
    
    GSGushiContentModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.nameStr;
    cell.textLabel.font = [UIFont fontWithName:_FontName size:_Font(20)];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        
        CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType: (NSString *)kUTTypeText];
        attributeSet.title = model.author;
        NSArray *arr = [model.nameStr componentsSeparatedByString:@"，"];
        NSArray *keyWord;
        if (arr.count > 1) {
            
            attributeSet.contentDescription = [NSString stringWithFormat:@"%@%@%@",arr[0],@"\n",arr[1]];
            keyWord = [NSArray arrayWithObjects:arr[0], arr[1], model.author, nil];
        } else {
            attributeSet.contentDescription = self.dataArray[indexPath.row].nameStr;
            keyWord = @[self.dataArray[indexPath.row].nameStr, model.author];
        }
        attributeSet.keywords = keyWord;
        CSSearchableItem *item = [[CSSearchableItem alloc]initWithUniqueIdentifier:@(model.shiID).description domainIdentifier:@"mingju" attributeSet:attributeSet];
        [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler:^(NSError * _Nullable error) {
            
        }];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GSDetailController *vc = [[GSDetailController alloc]init];
    vc.mingju = self.dataArray[indexPath.row].nameStr;
    vc.gushiID = self.dataArray[indexPath.row].shiID;
    [self.navigationController pushViewController:vc animated:YES];

}




@end
