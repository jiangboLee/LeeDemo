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

#import <UShareUI/UShareUI.h>

@interface GSDetailController ()<UITableViewDelegate,UITableViewDataSource,RemarksCellDelegate>

@property(nonatomic ,strong) UITableView *tableV;
@property(nonatomic ,strong) GSDetailContent *headerView;

// 存放cell视图展开状态的字典
@property (nonatomic, strong) NSMutableDictionary *cellIsShowAll;

@property(nonatomic ,copy) NSString *cont;

@end

@implementation GSDetailController

-(GSDetailContent *)headerView{

    if (_headerView == nil) {
        
        _headerView = [[[UINib nibWithNibName:@"GSDetailContent" bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
        _headerView.mingju = self.mingju;
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
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithTitle:@"share" style:UIBarButtonItemStylePlain target:self action:@selector(shareGushi)];
    self.navigationItem.rightBarButtonItem = share;
}
//分享
-(void)shareGushi{

    //配置上面需求的参数
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = YES;
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewTitleString = @"分享至";
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType =
    UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndBottom = 2;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndBottom = 3;
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;
    //去掉毛玻璃效果
    [UMSocialShareUIConfig shareInstance].shareContainerConfig.isShareContainerHaveGradient = NO;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType,NSDictionary *userInfo) {
       /*
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //设置文本
        messageObject.text = [NSString stringWithFormat:@"%@\n%@",self.headerView.nameStr.text,self.headerView.cont.text];//self.headerView.cont.text;
        messageObject.title = self.headerView.nameStr.text;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];
        */
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc]init];
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = [UIImage imageNamed:@"xiala"];
        
        UIGraphicsBeginImageContextWithOptions(self.headerView.bounds.size, NO, 0);
        [self.headerView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [shareObject setShareImage:image];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];
    }];//打开分享面板
}

//*****************************************************************//
//*****************************************************************//
-(void)setGushiID:(NSInteger)gushiID{

    _gushiID = gushiID;
    self.tableV.hidden = NO;
    [self showRefresh:self.view];
    [self loadData:gushiID];
}
-(void)loadData:(NSInteger)iid {
    
    
    NSDictionary *parmeters = @{@"id":@(iid),@"token":@"gswapi",@"random":@(2672180210)};
    NSString *urlStr;
    if (self.isMingjuSearch) {
        
        urlStr = @"http://app.gushiwen.org/api/mingju/ju.aspx";
    }else{
    
        urlStr = @"http://app.gushiwen.org/api/shiwen/view.aspx";
    }
    //    __weak typeof(self) weakSelf = self;
    [[LEEHTTPManager share] request:GET UrlString:urlStr parameters:parmeters finshed:
     ^(NSDictionary *responseObject, NSError *error) {
         
         if (error != nil) {
             [self hideHud];
             return ;
         }
         
         GSGushiContentModel *model = [GSGushiContentModel yy_modelWithDictionary:responseObject[@"tb_gushiwen"]];
         
         NSArray *fanyiArray = [NSArray yy_modelArrayWithClass:[GSGushiContentModel class] json:responseObject[@"tb_fanyis"][@"fanyis"]];
         
         NSArray *shangxiArray = [NSArray yy_modelArrayWithClass:[GSGushiContentModel class] json:responseObject[@"tb_shangxis"][@"shangxis"]];
         
         GSGushiContentModel *authorModel = [GSGushiContentModel yy_modelWithDictionary:responseObject[@"tb_author"]];
         //可能参数返回没有数据
         if (model.nameStr == nil) {
             [self hideHud];
             return;
         }
         NSMutableArray *array = [NSMutableArray arrayWithObject:model];
         if (((GSGushiContentModel *)(fanyiArray.firstObject)).nameStr != nil) {
             ((GSGushiContentModel *)(fanyiArray.firstObject)).cankao = @"fanyi";
             [array addObject:fanyiArray.firstObject];
         }
         if (((GSGushiContentModel *)(shangxiArray.firstObject)).cont != nil) {
             ((GSGushiContentModel *)(shangxiArray.firstObject)).cankao = @"shangxi";
             [array addObject:shangxiArray.firstObject];
         }
         if (authorModel.nameStr != nil) {
             
             [array addObject:authorModel];
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [self hideHud];
             self.dataArray = array;
             [self.tableV reloadData];
         });
         
     }];
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
    
    if (!model.isAreadlyRefresh && model.cankao != nil) {
        
        model.isAreadlyRefresh = YES;
        [self loadcont:model.gushiID type:model.cankao completed:^(NSString *cont) {
            
           cont = [cont stringByReplacingOccurrencesOfString:@"</strong><br />" withString:@": "];
            cont = [cont stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
            cont = [cont stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
            cont = [cont stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
            cont = [cont stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
            cont = [cont stringByReplacingOccurrencesOfString:@"<span style=\"font-family:FangSong_GB2312;\">" withString:@""];
            
            model.cont = cont;
            
            [self.tableV reloadData];
         }];
       
    }
    
    return [RemarksCellHeightModel cellHeightWith:model.cont andIsShow:[[self.cellIsShowAll objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]] boolValue] andLableWidth:[UIScreen mainScreen].bounds.size.width-30 andFont:_Font(16) andDefaultHeight:75 andFixedHeight:42 andIsShowBtn:8];
}

#pragma mark -- Dalegate
- (void)remarksCellShowContrntWithDic:(NSDictionary *)dic andCellIndexPath:(NSIndexPath *)indexPath
{
    [self.cellIsShowAll setObject:[dic objectForKey:@"isShow"] forKey:[NSString stringWithFormat:@"%@",[dic objectForKey:@"row"]]];
    
    [_tableV reloadData];
}

-(void)loadcont:(NSInteger)shiID type:(NSString *)typeStr completed:(void(^)(NSString *cont))completed{

    NSDictionary *parmeters = @{@"id":@(shiID),@"token":@"gswapi",@"random":@(2672180110)};
    NSString *urlStr = [NSString stringWithFormat:@"http://app.gushiwen.org/api/shiwen/%@.aspx",typeStr];//@"http://app.gushiwen.org/api/shiwen/%@.aspx";
//    __weak typeof(self) weakSelf = self;
    [[LEEHTTPManager share] request:GET UrlString:urlStr parameters:parmeters finshed:
     ^(NSDictionary *responseObject, NSError *error) {
         
         if (error != nil) {
             
             return ;
         }
         
         GSGushiContentModel *model = [GSGushiContentModel yy_modelWithDictionary:responseObject];
        
         completed(model.cont);
        
     }];

}





@end
