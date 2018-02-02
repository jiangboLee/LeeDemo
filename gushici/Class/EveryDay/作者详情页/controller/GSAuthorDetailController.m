//
//  GSAuthorDetailController.m
//  gushici
//
//  Created by 李江波 on 2017/2/16.
//  Copyright © 2017年 lijiangbo. All rights reserved.
//

#import "GSAuthorDetailController.h"
#import "GSGushiContentModel.h"
#import "RemarksTableViewCell.h"
#import "RemarksCellHeightModel.h"
#import <UIImageView+WebCache.h>
#import "GSDetailController.h"
#import "GSAuthorTableViewCell.h"

@interface GSAuthorDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong) UITableView *tableV;
@property(nonatomic ,strong) NSMutableArray *totaldataArray;

// 存放cell视图展开状态的字典
@property (nonatomic, strong) NSMutableDictionary *cellIsShowAll;

@property(nonatomic, assign) BOOL isZiliao;
@property(nonatomic, assign) BOOL isGushiwen;
@property(nonatomic, strong) NSMutableArray *ziliaoHeights;
@property(nonatomic, strong) NSMutableArray *ziliaoLessHeights;
@property(nonatomic, strong) NSMutableArray *gushiwenHeights;
@property(nonatomic, strong) NSMutableArray *gushiwenLessHeights;
@property(nonatomic, strong) NSMutableArray *allHeights;
@property(nonatomic, strong) NSMutableArray *allLessHeights;

@property(nonatomic, assign) CGFloat lessHeight;

@property(nonatomic ,strong) UIView *headerView;

@end

static NSString *GSAuthorTableViewCellId = @"GSAuthorTableViewCellId";
@implementation GSAuthorDetailController

-(UITableView *)tableV{
    
    if (_tableV == nil) {
        _tableV = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableV registerNib:[UINib nibWithNibName:@"GSAuthorTableViewCell" bundle:nil] forCellReuseIdentifier:GSAuthorTableViewCellId];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:_tableV];
        
    }
    return _tableV;
}

-(UIView *)headerView{

    if (_headerView == nil) {
        
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENW, 300)];
        UIImageView *imageV = [[UIImageView alloc]init];
        
        NSString *picName = self.model.pic.transformToPinyin;
        picName = [NSString stringWithFormat:@"http://img.gushiwen.org/authorImg/%@.jpg",picName];
        [imageV sd_setImageWithURL:[NSURL URLWithString:picName] placeholderImage:[UIImage imageNamed:@"logo"]];
        [_headerView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.equalTo(_headerView);
            make.width.offset(105);
            make.height.offset(150);
            make.top.equalTo(_headerView).offset(10);
        }];
        
        UILabel *lab = [[UILabel alloc]init];
        NSString *cont1 = [self.model.cont stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        NSString *cont2 = [cont1 stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        lab.text = cont2;
        lab.numberOfLines = 0;
        lab.font = [UIFont fontWithName:_FontName size:_Font(18)];//[UIFont systemFontOfSize:_Font(18)];
        [UILabel changeSpaceForLabel:lab withLineSpace:5 WordSpace:2];
        
        CGRect rect = [UILabel getLableRect:cont2 Size:CGSizeMake(UISCREENW-30, 4000) Font:[UIFont systemFontOfSize:lab.font.pointSize] LineSpace:5 WordSpace:2];
        
        [_headerView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(imageV.mas_bottom).offset(10);
            make.left.equalTo(_headerView).offset(15);
            make.right.equalTo(_headerView).offset(-15);
            make.bottom.offset(-10);
        }];
        _headerView.ljb_height = rect.size.height + 170;
        
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.nameStr;
    self.totaldataArray = [NSMutableArray array];
    self.ziliaoHeights = [NSMutableArray array];
    self.gushiwenHeights = [NSMutableArray array];
    self.ziliaoLessHeights = [NSMutableArray array];
    self.gushiwenLessHeights = [NSMutableArray array];
    self.allHeights = [NSMutableArray array];
    self.allLessHeights = [NSMutableArray array];
    self.cellIsShowAll = [NSMutableDictionary dictionary];
    self.lessHeight = [UIFont fontWithName:_FontName size:_Font(20)].lineHeight + [UIFont fontWithName:_FontName size:_Font(18)].lineHeight * 5 + 16 + 10;
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)setModel:(GSGushiContentModel *)model{

    _model = model;
    self.tableV.hidden = NO;
}

- (void)loadData{
    
    [self showRefresh:self.view];
    NSDictionary *parmeters = @{@"id":@(self.model.gushiID),@"token":@"gswapi",@"random":@(2672190210)};
    NSString *urlStr = @"http://app.gushiwen.org/api/author/author.aspx";
//    __weak typeof(self) weakSelf = self;
    [[LEEHTTPManager share] request:GET UrlString:urlStr parameters:parmeters finshed:
     ^(NSDictionary *responseObject, NSError *error) {
         [self hideHud];
         if (error != nil) {
             
             return ;
         }
         
         GSGushiContentModel *model = [GSGushiContentModel yy_modelWithDictionary:responseObject[@"tb_author"]];
         
         NSArray *ziliao = [NSArray yy_modelArrayWithClass:[GSGushiContentModel class] json:responseObject[@"tb_ziliaos"][@"ziliaos"]];
         
         NSArray *gushiwen = [NSArray yy_modelArrayWithClass:[GSGushiContentModel class] json:responseObject[@"tb_gushiwens"][@"gushiwens"]];
         
         if (ziliao.count != 0) {
             self.isZiliao = YES;
             [self.totaldataArray addObject:ziliao];
             //计算高度
             for (int i = 0; i < ziliao.count; i ++) {
                 GSGushiContentModel *model = ziliao[i];
                 CGFloat height = [self getLableHeight:model.cont];
                 [self.ziliaoHeights addObject:@(height)];
                 height > self.lessHeight ? [self.ziliaoLessHeights addObject:@(self.lessHeight)] : [self.ziliaoLessHeights addObject:@(height + 10)];
                 
             }
             [self.allHeights addObject:self.ziliaoHeights];
             [self.allLessHeights addObject:self.ziliaoLessHeights];
         }
         if (gushiwen.count != 0) {
             self.isGushiwen = YES;
             [self.totaldataArray addObject:gushiwen];
             //计算高度
             for (int i = 0; i < gushiwen.count; i ++) {
                 GSGushiContentModel *model = gushiwen[i];
                 CGFloat height = [self getLableHeight:model.cont];
                 [self.gushiwenHeights addObject:@(height)];
                 height > self.lessHeight ? [self.gushiwenLessHeights addObject:@(self.lessHeight)] : [self.gushiwenLessHeights addObject:@(height + 10)];
             }
             [self.allHeights addObject:self.gushiwenHeights];
             [self.allLessHeights addObject:self.gushiwenLessHeights];
         }
         self.model = model;
         _tableV.tableHeaderView = self.headerView;
         [self.tableV reloadData];
     }];
}

- (CGFloat)getLableHeight:(NSString *)contentStr {
    
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"</strong><br />" withString:@": "];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<span style=\"font-family:SimSun;\">" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<br />" withString:@":"];
    NSLog(@"%@",contentStr);
    CGRect rect = [UILabel getLableRect:contentStr Size:CGSizeMake(UISCREENW-30, 999999) Font:[UIFont fontWithName:_FontName size:_Font(18)] LineSpace:5 WordSpace:2];
    
    CGFloat wucha = rect.size.height / 200.0 * 3;
    return rect.size.height + [UIFont fontWithName:_FontName size:_Font(20)].lineHeight + 16 + wucha;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.totaldataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSArray *array = self.totaldataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GSAuthorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GSAuthorTableViewCellId forIndexPath:indexPath];
    cell.model = self.totaldataArray[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.needMoreButton.hidden = [self.allLessHeights[indexPath.section][indexPath.row] floatValue] != self.lessHeight;
    
    cell.lookMoreClickBlock = ^(BOOL more) {
        
        if (more) {
            self.allLessHeights[indexPath.section][indexPath.row] = self.allHeights[indexPath.section][indexPath.row];
        } else {
            self.allLessHeights[indexPath.section][indexPath.row] = @(self.lessHeight);
        }
        
/** 2018-02-02 15:00:40
        switch (indexPath.section) {
            case 0:
            {
                if (self.isZiliao) {
                    if (more) {
                        self.ziliaoLessHeights[indexPath.row] = self.ziliaoHeights[indexPath.row];
                    } else {
                        self.ziliaoHeights[indexPath.row] = @(self.lessHeight);
                    }
                } else {
                    if (more) {
                        self.gushiwenLessHeights[indexPath.row] = self.gushiwenHeights[indexPath.row];
                    } else {
                        self.gushiwenLessHeights[indexPath.row] = @(self.lessHeight);
                    }
                }
            }
                break;
            case 1:
            {
                if (more) {
                    self.gushiwenLessHeights[indexPath.row] = self.gushiwenHeights[indexPath.row];
                } else {
                    self.gushiwenLessHeights[indexPath.row] = @(self.lessHeight);
                }
            }
                break;
            default:
                break;
*/
//        }
        [tableView beginUpdates];
        [tableView endUpdates];
    };
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回Cell高度
    return  [self.allLessHeights[indexPath.section][indexPath.row] floatValue];
/** 2018-02-02 14:56:55
    switch (indexPath.section) {
        case 0:
        {
            if (self.isZiliao) {
                return [self.ziliaoLessHeights[indexPath.row] floatValue];
            } else {
                return [self.gushiwenLessHeights[indexPath.row] floatValue];
            }
        }
            break;
        case 1:
        {
            return [self.gushiwenLessHeights[indexPath.row] floatValue];
        }
            break;
        default:
            return 44;
            break;
    }
*/
    
    
}

/** 2018-02-02 13:46:26
-(void)loadcont:(NSInteger)shiID completed:(void(^)(NSString *cont))completed{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://app.gushiwen.org/api/author/ziliao.aspx?id=%zd&token=gswapi&random=2557059046",shiID];
    //    __weak typeof(self) weakSelf = self;
    [[LEEHTTPManager share] request:GET UrlString:urlStr parameters:nil finshed:
     ^(NSDictionary *responseObject, NSError *error) {
         
         if (error != nil) {
             
             return ;
         }
         
         GSGushiContentModel *model = [GSGushiContentModel yy_modelWithDictionary:responseObject];
         
         completed(model.cont);
         
     }];
    
}
*/

//#pragma mark -- Dalegate
//- (void)remarksCellShowContrntWithDic:(NSDictionary *)dic andCellIndexPath:(NSIndexPath *)indexPath
//{
//    [self.cellIsShowAll setObject:[dic objectForKey:@"isShow"] forKey:[NSString stringWithFormat:@"%@",[dic objectForKey:@"row"]]];
//
//    [_tableV reloadData];
//}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    switch (section) {
        case 0:
        {
            if (self.isZiliao) {
                return @"作者资料";
            } else {
                return @"相关作品";
            }
        }
            break;
        case 1:
            return @"相关作品";
            break;
        default:
            return @"";
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (!self.isZiliao) {
                [self gotoDetailVC:indexPath];
            }
        }
            break;
        case 1:
        {
            [self gotoDetailVC:indexPath];
        }
            break;
        default:
            break;
    }
}

- (void)gotoDetailVC:(NSIndexPath *)indexPath {
    GSDetailController *vc = [[GSDetailController alloc]init];
    GSGushiContentModel *model = self.totaldataArray[indexPath.section][indexPath.row];
    vc.gushiID = model.gushiID;
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
