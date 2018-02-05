//
//  GSPageViewController.m
//  gushici
//
//  Created by ljb48229 on 2018/2/5.
//  Copyright © 2018年 lijiangbo. All rights reserved.
//

#import "GSPageViewController.h"
#import "GSGushiContentModel.h"
#import "GSCardViewController.h"

@interface GSPageViewController ()<UIPageViewControllerDataSource>

@property(nonatomic ,strong) NSMutableArray<GSGushiContentModel *> *contentModels;
@property(nonatomic ,strong) NSMutableArray *dataArrays;
@property(nonatomic ,strong) NSMutableArray *gushiIdArrays;

@property(nonatomic, weak) UIViewController *lastVC;
@property(nonatomic, strong) NSDate *lastDate;
@end

@implementation GSPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_bg"]];
    imgView.frame = self.view.bounds;
    [self.view insertSubview:imgView atIndex:0];
    
    self.navigationItem.title = _Str(@"每日推荐");
    self.contentModels = [NSMutableArray array];
    self.dataArrays = [NSMutableArray array];
    self.gushiIdArrays = [NSMutableArray array];
    
    //监听网络
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            
            [self reload];
        }
    }];
    //注册重新刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataAction) name:RELOADGUSHINotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataAction2) name:@"doubleClickDidSelectedNotification" object:nil];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reload{
    
    [SVProgressHUD show];
    for (int i = 0; i < 3; i++) {
        [self loadData];
    }
}

-(void)loadData{
    
    NSInteger iid = arc4random_uniform(50000);
    NSDictionary *parmeters = @{@"id":@(iid),@"token":@"gswapi",@"random":@(2672180210)};
    NSString *urlStr = @"http://app.gushiwen.org/api/shiwen/view.aspx";
    __weak typeof(self) weakSelf = self;
    [[LEEHTTPManager share] request:GET UrlString:urlStr parameters:parmeters finshed:
     ^(NSDictionary *responseObject, NSError *error) {
         
         if (error != nil) {
             [SVProgressHUD dismiss];
             return ;
         }
         
         GSGushiContentModel *model = [GSGushiContentModel yy_modelWithDictionary:responseObject[@"tb_gushiwen"]];
         //可能参数返回没有数据
         if (model.nameStr == nil) {
             [weakSelf loadData];
             return;
         }
         [weakSelf.contentModels addObject:model];
         [weakSelf.dataArrays addObject:responseObject];
         [weakSelf.gushiIdArrays addObject:@(iid)];
         [SVProgressHUD dismiss];
         
         if (weakSelf.gushiIdArrays.count == 3) {
             [SVProgressHUD dismiss];
             weakSelf.dataSource = self;
             [weakSelf setViewControllers:@[[self viewControllerForPage:0]] direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
         }
     }];
}

#pragma mark: - datasourse
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    GSCardViewController *vc = (GSCardViewController *)viewController;
    NSInteger pageIndex = vc.pageIndex;
    if (pageIndex >= self.dataArrays.count - 1) {
        return nil;
    }
    return [self viewControllerForPage:pageIndex + 1];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    GSCardViewController *vc = (GSCardViewController *)viewController;
    NSInteger pageIndex = vc.pageIndex;
    if (pageIndex <= 0) {
        return nil;
    }
    return [self viewControllerForPage:pageIndex - 1];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.dataArrays.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    GSCardViewController *cardVC = pageViewController.viewControllers[0];
    NSInteger currentPageIndex = cardVC.pageIndex;
    return currentPageIndex;
}

- (GSCardViewController *)viewControllerForPage:(NSInteger)page {
    
    GSCardViewController *cardVC = [[GSCardViewController alloc]init];
    cardVC.pageIndex = page;
    cardVC.model = self.contentModels[page];
    cardVC.dataDic = self.dataArrays[page];
    return cardVC;
}


#pragma mark : - action
- (void)reloadDataAction {
    
    [self.contentModels removeAllObjects];
    [self.gushiIdArrays removeAllObjects];
    [self.dataArrays removeAllObjects];
    [self reload];
}

- (void)reloadDataAction2 {
    
    _lastVC = self.tabBarController.selectedViewController;
    if ([self.lastVC isKindOfClass:[self.navigationController class]] && self.view.window) {
        
        NSDate *date = [[NSDate alloc]init];
        if (date.timeIntervalSince1970 - _lastDate.timeIntervalSince1970 < 0.5) {
            [self.contentModels removeAllObjects];
            [self.gushiIdArrays removeAllObjects];
            [self.dataArrays removeAllObjects];
            [self reload];
        }
        _lastDate = date;
    }
}

@end
