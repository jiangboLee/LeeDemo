//
//  GSSearchController.m
//  gushici
//
//  Created by 李江波 on 2017/2/12.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSSearchController.h"
#import "PYSearchSuggestionViewController.h"
#import "GSSearchEditModel.h"
#import "GSSearchSuggestionView.h"


@interface GSSearchController ()<PYSearchViewControllerDelegate,PYSearchViewControllerDataSource>

@property(nonatomic ,strong) PYSearchViewController *searchViewController;

@property(nonatomic ,strong) NSMutableDictionary *dict1;
@property(nonatomic ,strong) NSMutableDictionary *dict2;
@property(nonatomic ,strong) NSMutableDictionary *dict3;
@property(nonatomic ,strong) NSMutableDictionary *dict4;
@property(nonatomic ,strong) NSMutableArray *arrays;

@end


@implementation GSSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dict1 = [NSMutableDictionary dictionary];
    self.dict2 = [NSMutableDictionary dictionary];
    self.dict3 = [NSMutableDictionary dictionary];
    self.dict4 = [NSMutableDictionary dictionary];
    self.arrays = [NSMutableArray array];
    
    // 1.创建热门搜索
    NSArray *hotSeaches = @[@"李白", @"杜甫", @"苏轼", @"岳飞", @"杜牧", @"李商隐", @"虞美人", @"将进酒", @"满江红"];
    // 2. 创建控制器
    _searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"请输入搜索内容" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // 开始搜索执行以下代码
        // 如：跳转到指定控制器
        [searchViewController.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
    }];
    _searchViewController.hotSearchStyle = PYHotSearchStyleDefault; // 热门搜索风格为默认
    _searchViewController.searchHistoryStyle = PYSearchHistoryStyleCell; // 搜索历史风格根据选择
    // 4. 设置代理
    _searchViewController.delegate = self;
    _searchViewController.dataSource = self;
    
    _searchViewController.searchSuggestionHidden = NO;
    
    [self setViewControllers:@[_searchViewController] animated:NO];
}


#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
   //边输入边弹框
    if (searchText.length) { // 与搜索条件再搜索
        NSLog(@"searchText :%@",searchText);
        [self.arrays removeAllObjects];
        
        NSString *urlStr = [NSString stringWithFormat:@"http://app.gushiwen.org/api/ajaxSearch.aspx?n=232105204&token=gswapi&valuekey=%@",searchText];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[LEEHTTPManager share] request:GET UrlString:urlStr parameters:nil finshed:^(NSDictionary *responseObject, NSError *error) {
           
            NSArray<GSSearchEditModel *> *gushiwenArray = [NSArray yy_modelArrayWithClass:[GSSearchEditModel class] json:responseObject[@"gushiwens"]];
            
            NSArray<GSSearchEditModel *> *mingjuArray = [NSArray yy_modelArrayWithClass:[GSSearchEditModel class] json:responseObject[@"mingjus"]];
            
            NSArray<GSSearchEditModel *> *authorArray = [NSArray yy_modelArrayWithClass:[GSSearchEditModel class] json:responseObject[@"authors"]];
            NSArray<GSSearchEditModel *> *typekeysArray = [NSArray yy_modelArrayWithClass:[GSSearchEditModel class] json:responseObject[@"typekeys"]];
            
            if (gushiwenArray.count != 0) {
                
                self.dict1[@"gushiwens"] = gushiwenArray;
                [self.arrays addObject:self.dict1];
            }
            if (mingjuArray.count != 0) {
                
                self.dict2[@"mingjus"] = mingjuArray;
                [self.arrays addObject:self.dict2];
            }
            if (authorArray.count != 0){
            
                self.dict3[@"authors"] = authorArray;
                [self.arrays addObject:self.dict3];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(typekeysArray.count != 0){
                    
                    self.dict4[@"typekeys"] = typekeysArray;
                    [self.arrays addObject:self.dict4];
                }
                // 显示建议搜索结果
                            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
                            for (int i = 0; i < self.arrays.count  + 1; i++) {
                                NSString *searchSuggestion = [NSString stringWithFormat:@"搜索建议 %d", i];
                                [searchSuggestionsM addObject:searchSuggestion];
                            }
                            // 返回
                            searchViewController.searchSuggestions = searchSuggestionsM;
            });
            
        }];
        
//        // 根据条件发送查询（这里模拟搜索）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 搜索完毕
//            // 显示建议搜索结果
//            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
//            for (int i = 0; i < 10; i++) {
//                NSString *searchSuggestion = [NSString stringWithFormat:@"搜索建议 %d", i];
//                [searchSuggestionsM addObject:searchSuggestion];
//            }
//            // 返回
//            searchViewController.searchSuggestions = searchSuggestionsM;
//        });
    }

    
}
#pragma mark - PYSearchViewControllerDatasouse
/** 返回用户自定义搜索建议cell的rows */
- (NSInteger)searchSuggestionView:(UITableView *)searchSuggestionView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrays.count == 0 ? 1 :self.arrays.count;
}
/** 返回用户自定义搜索建议cell的section */
- (NSInteger)numberOfSectionsInSearchSuggestionView:(UITableView *)searchSuggestionView{

    return 1;
}
/** 返回用户自定义搜索建议Cell */
- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"CELLID";
    [searchSuggestionView registerNib:[UINib nibWithNibName:@"GSSearchSuggestionView" bundle:nil] forCellReuseIdentifier:cellID];
    GSSearchSuggestionView *cell = [searchSuggestionView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if(self.arrays.count != 0){
        cell.dict = self.arrays[indexPath.row];
        return cell;
    }else{
    
        cell.dict = @{@"wu":@"搜不到哦"};
        return cell;
    }
}
/** 返回用户自定义搜索建议cell高度 */
- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}


-(void)didClickCancel:(PYSearchViewController *)searchViewController{

    
}




@end
