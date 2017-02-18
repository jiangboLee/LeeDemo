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

@interface GSAuthorDetailController ()<UITableViewDelegate,UITableViewDataSource,RemarksCellDelegate>

@property(nonatomic ,strong) UITableView *tableV;
@property(nonatomic ,strong) NSMutableArray *totaldataArray;

// 存放cell视图展开状态的字典
@property (nonatomic, strong) NSMutableDictionary *cellIsShowAll;

@property(nonatomic ,assign) BOOL isZiliao;
@property(nonatomic ,assign) BOOL isGushiwen;

@property(nonatomic ,strong) UIView *headerView;

@end

@implementation GSAuthorDetailController

-(UITableView *)tableV{
    
    if (_tableV == nil) {
        _tableV = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.tableFooterView = [[UIView alloc]init];
        
        _tableV.tableHeaderView = self.headerView;
        
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
        [imageV sd_setImageWithURL:[NSURL URLWithString:picName]];
        
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
        lab.font = [UIFont systemFontOfSize:_Font(18)];
        
        CGRect rect = [cont2 boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-30, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:lab.font.pointSize]} context:nil];
        
        [_headerView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(imageV.mas_bottom).offset(5);
            make.left.equalTo(_headerView).offset(15);
            make.right.equalTo(_headerView).offset(-15);
            make.height.offset(rect.size.height + 2);
            
        }];
        _headerView.ljb_height = rect.size.height + 170;
        
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.totaldataArray = [NSMutableArray array];
    self.cellIsShowAll = [NSMutableDictionary dictionary];
    
    [self loadData];
    
}
-(void)setModel:(GSGushiContentModel *)model{

    _model = model;
    self.tableV.hidden = NO;
}

-(void)loadData{

    NSDictionary *parmeters = @{@"id":@(self.model.gushiID),@"token":@"gswapi",@"random":@(2672190210)};
    NSString *urlStr = @"http://app.gushiwen.org/api/author/author.aspx";
//    __weak typeof(self) weakSelf = self;
    [[LEEHTTPManager share] request:GET UrlString:urlStr parameters:parmeters finshed:
     ^(NSDictionary *responseObject, NSError *error) {
         
         if (error != nil) {
             
             return ;
         }
         
//         GSGushiContentModel *model = [GSGushiContentModel yy_modelWithDictionary:responseObject[@"tb_author"]];
         
         NSArray *ziliao = [NSArray yy_modelArrayWithClass:[GSGushiContentModel class] json:responseObject[@"tb_ziliaos"][@"ziliaos"]];
         
         NSArray *gushiwen = [NSArray yy_modelArrayWithClass:[GSGushiContentModel class] json:responseObject[@"tb_gushiwens"][@"gushiwens"]];
         
         if (ziliao.count != 0) {
             self.isZiliao = YES;
             [self.totaldataArray addObject:ziliao];
         }
         if (gushiwen.count != 0) {
             self.isGushiwen = YES;
             [self.totaldataArray addObject:gushiwen];
         }
         
         
         [self.tableV reloadData];
     }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.totaldataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSArray *array = self.totaldataArray[section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellName = @"meTableViewCell";
    RemarksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[RemarksTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GSGushiContentModel *model = self.totaldataArray[indexPath.section][indexPath.row];
    
    cell.infolable.text = model.nameStr;
    
    [cell setCellContent:model.cont andIsShow:[[self.cellIsShowAll objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]] boolValue]  andCellIndexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回Cell高度
    
    GSGushiContentModel *model = self.totaldataArray[indexPath.section][indexPath.row];
    
    if (!model.isAreadlyRefresh) {
    
        if (self.isZiliao && model.author != nil) {
            
            model.isAreadlyRefresh = YES;
            [self loadcont:model.gushiID  completed:^(NSString *cont) {
                
                cont = [cont stringByReplacingOccurrencesOfString:@"</strong><br />" withString:@": "];
                cont = [cont stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
                cont = [cont stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
                cont = [cont stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
                
                model.cont = cont;
                
                [self.tableV reloadData];
            }];
        }
        
    }
    
    return [RemarksCellHeightModel cellHeightWith:model.cont andIsShow:[[self.cellIsShowAll objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]] boolValue] andLableWidth:[UIScreen mainScreen].bounds.size.width-30 andFont:_Font(16) andDefaultHeight:75 andFixedHeight:42 andIsShowBtn:8];
}

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


#pragma mark -- Dalegate
- (void)remarksCellShowContrntWithDic:(NSDictionary *)dic andCellIndexPath:(NSIndexPath *)indexPath
{
    [self.cellIsShowAll setObject:[dic objectForKey:@"isShow"] forKey:[NSString stringWithFormat:@"%@",[dic objectForKey:@"row"]]];
    
    [_tableV reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    if (self.isZiliao && self.isGushiwen) {
        
        switch (section) {
            case 0:
                return @"作者资料";
                break;
            case 1:
                return @"相关作品";
                break;
            default:
                break;
        }
    }else if (self.isZiliao){
    
        return @"作者资料";
    }
    
    return @"相关作品";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        
        GSDetailController *vc = [[GSDetailController alloc]init];
        GSGushiContentModel *model = self.totaldataArray[indexPath.section][indexPath.row];
        vc.gushiID = model.gushiID;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
